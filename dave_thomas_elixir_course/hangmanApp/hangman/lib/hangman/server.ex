defmodule Hangman.Server do
  alias Hangman.Game

  # predefines a bunch of callbacks (~9 in Erlang)
  use GenServer

  # to kick off a server process
  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  # callbacks that will be used by the process that begins

  # will create the state returned by init cb
  def init(_) do
    IO.puts("new game created")
    {:ok, Game.new_game()}
  end

  def handle_call({:request_move, guess}, _from, game) do
    {game, tally} = Game.request_move(game, guess)
    {:reply, tally, game}
  end

  def handle_call({:tally}, _from, game), do: {:reply, Game.tally(game), game}
end
