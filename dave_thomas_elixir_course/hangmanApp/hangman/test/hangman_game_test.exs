defmodule HangmanGameTest do
  use ExUnit.Case
  alias Hangman.Game

  test "new_game returns right structure" do
    game = Game.new_game()

    assert game.turn_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
    assert Enum.all?(game.letters, &Regex.match?(~r/[a-z]/, &1))
  end

  test "return same game when game is already :won or :lost" do
    for state <- [:won, :lost] do
      game =
        Game.new_game()
        |> Map.put(:game_state, state)

      assert {^game, _} = Game.request_move(game, "x")
    end
  end

  test "change game_state to :already_used if guess already done" do
    {game, _} =
      Game.new_game()
      |> Map.put(:used_letters, ["a"])
      |> Game.request_move("a")

    assert game.game_state == :already_used
  end

  test "adding a letter if not already used" do
    {game, _} =
      Game.new_game()
      |> Game.request_move("a")

    assert Enum.member?(game.used_letters, "a") == true
  end

  test "good guess" do
    {game, _} =
      Game.new_game("jerome")
      |> Game.request_move("j")

    assert game.game_state == :good_guess
    assert game.turn_left == 7
  end

  test "bad guess" do
    {game, _} =
      Game.new_game("jerome")
      |> Game.request_move("a")

    assert game.game_state == :bad_guess
    assert game.turn_left == 6
  end

  test "won game" do
    {game, _} =
      Game.new_game("je")
      |> Game.request_move("j")

    {game, _} = Game.request_move(game, "e")

    assert game.used_letters == ["e", "j"]
    assert game.letters == ["j", "e"]
    assert game.game_state == :won
  end

  test "lost game" do
    moves = [
      ["h", :bad_guess, 6],
      ["i", :bad_guess, 5],
      ["j", :bad_guess, 4],
      ["k", :bad_guess, 3],
      ["l", :bad_guess, 2],
      ["m", :bad_guess, 1],
      ["n", :lost, 0]
    ]

    game = Game.new_game("abcdeff")
    assert game.game_state == :initializing
    assert game.turn_left == 7

    last_game =
      Enum.reduce(moves, game, fn move, curren_game ->
        [guess, state, turn] = move
        {new_game, _} = Game.request_move(curren_game, guess)
        assert new_game.game_state == state
        assert new_game.turn_left == turn
        new_game
      end)

    assert last_game.game_state == :lost
  end

  # test "tally" do
  #  { game, tally } = Game.new_game("piroska")
  #                    |> Game.request_move("p")
  #  assert tally.turn_left == 7
  #  assert tally.game_state == :good_guess
  #  assert tally.letters == ["p", "-", "-", "-", "-", "-", "-"]
  #  { game, tally } = Game.request_move(game, "z")
  #  assert tally.turn_left == 6
  #  assert tally.game_state == :bad_guess
  #  assert tally.letters == ["p", "-", "-", "-", "-", "-", "-"]
  # end
end
