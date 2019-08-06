# The API and strictly 
defmodule Hangman do
  # alias Hangman.Game as: Game
  # shorcuit ->
  # alias Hangman.Server
  # def new_game do
  #  Game.new_game()
  ## end
  # it is not clear and as I just delegate to the module
  # a better solution here is to use defdelegate
  # It is clear now that the method I call is decoupled from the API

  def new_game() do
    {_, pid} = Supervisor.start_child(Hangman.Supervisor, [])
    pid
  end

  def tally(game_server_pid), do: GenServer.call(game_server_pid, {:tally})

  def request_move(game_server_pid, guess) do
    GenServer.call(game_server_pid, {:request_move, guess})
  end
end
