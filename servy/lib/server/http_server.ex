# server() ->
#    {ok, LSock} = gen_tcp:listen(5678, [binary, {packet, 0}, 
#                                        {active, false}]),
#    {ok, Sock} = gen_tcp:accept(LSock),
#    {ok, Bin} = do_recv(Sock, []),
#    ok = gen_tcp:close(Sock),
#    ok = gen_tcp:close(LSock),
#    Bin.

defmodule Servy.HttpServer do
  alias Servy.{Handler, PledgeServer, FourOhFourCounter}

  def start(port) when is_integer(port) and port > 1023 do
    #PledgeServer.start_link([])
    #FourOhFourCounter.start()

    port
    |> listen
    |> accept_requests
  end

  defp listen(port) do
    {:ok, listening_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("Listening incoming requests on port #{port}\n")
    listening_socket
  end

  defp accept_requests(lsock) do
    {:ok, client_sock} = accept(lsock)
    pid = spawn(fn -> serve_request(client_sock) end)
    :ok = :gen_tcp.controlling_process(client_sock, pid)
    accept_requests(lsock)
  end

  defp serve_request(csock) do
    {:ok, csock}
    |> receive_request
    |> generate_response
    |> send_response
    |> close
  end

  defp accept(lsock) do
    IO.puts("Connection accepted")
    {:ok, client_sock} = :gen_tcp.accept(lsock)
    IO.inspect(client_sock)
    {:ok, client_sock}
  end

  defp receive_request({:ok, csock}) do
    IO.puts("Received request:\n")
    # receive all in binaries
    {:ok, request_bin} = :gen_tcp.recv(csock, 0)
    IO.puts(request_bin)
    {request_bin, csock}
  end

  defp generate_response({request_bin, csock}) do
    response = Handler.handle(request_bin)
    {response, csock}
  end

  defp send_response({response, csock}) do
    IO.puts("Send a response")
    :ok = :gen_tcp.send(csock, response)
    csock
  end

  defp close(csock) do
    IO.puts("Connection closed")
    :ok = :gen_tcp.close(csock)
  end
end
