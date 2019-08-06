defmodule Servy.Client do
  def start(port, path, method \\ "GET", body \\ "") when is_integer(port) and port > 1023 do
    host = 'localhost'

    host
    |> connect(port)
    |> send_request(path, method, body)
    |> receive_response
    |> close
  end

  defp connect(host, port) do
    {:ok, _sock} = :gen_tcp.connect(host, port, [:binary, packet: :raw, active: false])
  end

  defp send_request({:ok, sock}, path, method, body) do
    request =
      """
      #{method} #{path} HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Content-Type: application/x-www-form-urlencoded\r
      Accept: */*\r
      \r
      """ <> body

    :ok = :gen_tcp.send(sock, request)
    sock
  end

  defp receive_response(sock) do
    response = :gen_tcp.recv(sock, 0)
    {sock, response}
  end

  defp close({sock, response}) do
    :ok = :gen_tcp.close(sock)
    response
  end
end
