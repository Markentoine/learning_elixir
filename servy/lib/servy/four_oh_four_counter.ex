defmodule Servy.FourOhFourCounter do
  alias Servy.GenericServer

  @counter :four_oh_four_counter

  def start(initial_state \\ %{}) do
    GenericServer.start(__MODULE__, initial_state, @counter)
  end

  # SPECIFIC MESSAGES WILL BE HANDLED BY THE GENERIC SERVER

  def handle_call({:bump_count, path}, state) do
    previous_count = Map.get(state, path, 0)
    new_state = Map.put(state, path, previous_count + 1)
    {:incremented, new_state}
  end

  def handle_call({:get_count, path}, state) do
    {Map.get(state, path, 0), state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_cast(:clear, _state) do
    %{}
  end

  def handle_info(msg, state) do
    IO.puts("Unexpected message: #{msg}")
  end

  # INTERFACE

  def bump_count(path) do
    GenericServer.call(@counter, {:bump_count, path})
  end

  def get_count(path) do
    GenericServer.call(@counter, {:get_count, path})
  end

  def get_counts do
    GenericServer.call(@counter, :get_counts)
  end

  def clear_counts do
    # NO RESPONSE
    GenericServer.cast(@counter, :clear)
  end
end
