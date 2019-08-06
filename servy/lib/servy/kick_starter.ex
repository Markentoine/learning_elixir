defmodule Servy.KickStarter do
    use GenServer

    def start_link(_arg) do
        IO.puts "Starting the kickstarter"
        GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
    end

    def init(:ok) do
        Process.flag(:trap_exit, true)
        server_pid = start_server()
        {:ok, server_pid}
    end

    def handle_info({:EXIT, _pid, reason}, _state) do
        IO.puts "Exit info: #{inspect reason}"
        server_pid = start_server()
        {:noreply, server_pid}
    end

    defp start_server() do
        IO.puts "Starting a new web server..."
        port = Application.get_env(:servy, :port)
        server_pid = spawn_link(Servy.HttpServer, :start, [port])
        # processes run in isolation but by linking them, their destiny is linked.
        #Process.link(server_pid) shorcuited with spawn_link instead: of spawn then link
        Process.register(server_pid, :http_server)
        server_pid
    end

    def get_server do
        GenServer.call(__MODULE__, :get_server)
    end

    def handle_call(:get_server, _from, state) do
        {:reply, state, state}
    end
end