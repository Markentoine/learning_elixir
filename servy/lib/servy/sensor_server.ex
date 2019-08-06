defmodule Servy.SensorServer do
  use GenServer

  alias Servy.{VideoCam, Tracker, SensorDataState}

  @name :sensor_server

  def start_link(interval) do
    IO.puts "Starting the sensor server with #{interval} min refresh..."
    GenServer.start_link(__MODULE__, %SensorDataState{interval: :timer.seconds(interval)}, name: @name)
  end

  def get_sensor_data() do
    GenServer.call(@name, :get_sensor_data)
  end

  def set_refresh_interval(interval) do
    GenServer.cast(@name, {:set_interval, interval})
  end

  # CALLBACKS

  def init(state) do
    initial_datas = run_tasks_to_get_sensors_data()
    refresh_cache(state)
    {:ok, %{state | data: initial_datas}}
  end

  def handle_cast({:set_interval, interval}, state) do
    new_state = %{state | interval: interval}
    {:noreply, new_state}
  end

  def handle_info(:refresh, state) do
    IO.puts("Cache is refreshed...")
    new_datas = run_tasks_to_get_sensors_data()
    refresh_cache(state)
    {:noreply, %{state | data: new_datas}}
  end

  def handle_info(unexpected_message, state) do
    IO.puts("Hey! Unexpected Message received: #{unexpected_message}")
    {:noreply, state}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state.data, state}
  end

  defp refresh_cache(state) do
    Process.send_after(self(), :refresh, state.interval)
  end

  defp run_tasks_to_get_sensors_data do
    task = Task.async(Tracker, :get_location, ["roscoe"])

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    coord_roscoe = Task.await(task)

    %{snapshots: snapshots, location: coord_roscoe}
  end
end
