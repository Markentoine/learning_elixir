defmodule Hangman.Game do
  defstruct turn_left: 7, game_state: :initializing, letters: [], used_letters: [], word_length: 0

  def new_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints(),
      word_length: String.length(word)
    }
  end

  def new_game(), do: new_game(Dictionary.random_word())

  def tally(game),
    do: %{
      turn_left: game.turn_left,
      game_state: game.game_state,
      letters: reveal_letters(game),
      word_length: game.word_length,
      used_letters: game.used_letters
    }

  def request_move(game, guess) do
    guess
    |> check_guess
    |> send_move(game, guess)
  end

  # private #################################################################################

  defp send_move(_send = true, game, guess) do
    make_move(game, String.downcase(guess))
    |> return_with_tally
  end

  defp send_move(_send = :error, game, _guess) do
    IO.puts("bad input")
    return_with_tally(game)
  end

  defp check_guess(guess), do: String.match?(guess, ~r/\A[a-z]\z/i) || :error

  defp return_with_tally(game), do: {game, tally(game)}

  defp make_move(game = %{game_state: state}, _guess) when state in [:won, :lost], do: game

  defp make_move(game, guess),
    do: process_move(game, guess, Enum.member?(game.used_letters, guess))

  defp reveal_letters(game) do
    Enum.map(game.letters, &select_letters(&1, Enum.member?(game.used_letters, &1)))
  end

  defp select_letters(letter, _found_letter = true), do: letter
  defp select_letters(_letter, _not_found_letter), do: "-"

  defp process_move(game, _guess, _already_used_letter = true),
    do: change_state(game, :already_used)

  defp process_move(game, guess, _not_already_used_letter) do
    game =
      add_used_letter(game, guess)
      |> evaluate_guess(Enum.member?(game.letters, guess))

    evaluate_end_game(game, won?(game), lost?(game))
  end

  defp evaluate_guess(game, _good_guess = true), do: change_state(game, :good_guess)

  defp evaluate_guess(game, _bad_guess) do
    change_state(game, :bad_guess)
    |> decrement_turn
  end

  defp evaluate_end_game(game, _won = true, _not_lost), do: change_state(game, :won)
  defp evaluate_end_game(game, _not_won, _lost = true), do: change_state(game, :lost)
  defp evaluate_end_game(game, _not_won, _not_lost), do: game

  defp change_state(game, state), do: Map.put(game, :game_state, state)

  defp add_used_letter(game, letter) do
    Map.put(game, :used_letters, [letter | game.used_letters])
  end

  defp decrement_turn(game) do
    %{turn_left: current_turn_left} = game
    Map.put(game, :turn_left, current_turn_left - 1)
  end

  defp won?(game), do: Enum.all?(game.letters, &Enum.member?(game.used_letters, &1))
  defp lost?(game), do: game.turn_left == 0
end
