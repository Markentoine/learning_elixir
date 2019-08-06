defmodule Servy.PledgeServer do
  use GenServer #restart: :temporary # overides the child_spec
  # also possible to overides through our own chil_spec function 

  alias Servy.State

  @name :pledge_server

  def start_link(_args) do
    IO.puts "Starting the pledgeserver..."
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  # INTERFACE

  def create_pledge(name, amount) do
    GenServer.call(@name, {:create_pledge, name, amount})
  end

  def recent_pledges() do
    GenServer.call(@name, :recent_pledges)
  end

  def total_pledges() do
    GenServer.call(@name, :total_pledges)
  end

  def clear do
    GenServer.cast(@name, :clear)
  end

  def set_cache_size(size) do
    GenServer.cast(@name, {:set_cache, size})
  end

  # SERVER CALLBACKS

  def init(state) do
    fetched_pledges = fetch_recent_pledges_from_service()
    new_state = %{state | pledges: fetched_pledges}
    {:ok, new_state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_external_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call(:total_pledges, _from, state) do
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum()
    {:reply, total, state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache, size}, state) do
    {:noreply, %{state | cache_size: size}}
  end

  defp send_pledge_to_external_service(_name, _amount) do
    {:ok, "pledge-#{:rand.uniform(10000)}"}
  end

  def fetch_recent_pledges_from_service() do
    [{"piroska", 200}, {"sacha", 300}, {"jerome", 100}, {"Celine", 600}, {"Stephane", 700}]
  end
end
