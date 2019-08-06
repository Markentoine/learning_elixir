defmodule ServyServerTest do
  use ExUnit.Case

  alias Servy.{HttpServer, Client}

  @tag timeout: 3000

  test "Server" do
    start_server(5000)
    {:ok, response} = Client.start(5000, "/api/languages")

    expected_response =
      "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: 399\r\n\n[{\"type\":\"OOP\",\"name\":\"Ruby\",\"id\":1,\"friendly\":true},{\"type\":\"OOP\",\"name\":\"Java\",\"id\":2,\"friendly\":false},{\"type\":\"Functional\",\"name\":\"Elixir\",\"id\":3,\"friendly\":true},{\"type\":\"OOP\",\"name\":\"JS\",\"id\":4,\"friendly\":false},{\"type\":\"Imperative\",\"name\":\"Assembly\",\"id\":5,\"friendly\":false},{\"type\":\"OOP\",\"name\":\"Python\",\"id\":6,\"friendly\":true},{\"type\":\"Functional\",\"name\":\"Haskell\",\"id\":7,\"friendly\":false}]\n"

    assert expected_response == response
  end

  test "With task" do
    start_server(5000)
    task = Task.async(fn -> Client.start(5000, "/sensors") end)
    response = Task.await(task)

    assert response ===
             {:ok,
              "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 210\r\n\n<h1>PHOTOS</h1>\n<ul>\n    <li>Photo: cam-1-snapshot.jpg</li><li>Photo: cam-2-snapshot.jpg</li><li>Photo: cam-3-snapshot.jpg</li>\n</ul>\n<h1>Coordinates</h1>\n<p>Latitude: 44.4280 N</p>\n<p>Longitude: 110.5885 W</p>\n"}
  end

  test "multiple url" do
    start_server(5000)

    check =
      ["/sensors", "/languages", "/frameworks"]
      |> Enum.map(&run_tasks/1)
      |> Enum.map(&Task.await/1)
      |> Enum.all?(&response_ok/1)

    assert check == true
  end

  test "pledges" do
    start_server(5000)
    Client.start(5000, "/pledges", "POST", "name=kyotaro&amount=400")
    task = Task.async(fn -> Client.start(5000, "/pledges") end)
    response = Task.await(task)

    assert response ==
             {:ok,
              "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 52\r\n\n[{\"kyotaro\", 400}, {\"piroska\", 200}, {\"sacha\", 300}]\n"}
  end

  test "no route found" do
    start_server(5000)
    task = Task.async(fn -> Client.start(5000, "/library") end)
    response = Task.await(task)

    assert response ==
             {:ok,
              "HTTP/1.1 404 Not Found\r\nContent-Type: text/html\r\nContent-Length: 0\r\n\n\n"}
  end

  defp run_tasks(url) do
    Task.async(fn -> Client.start(5000, url) end)
  end

  defp response_ok({:ok, resp}) do
    [headers, _] = String.split(resp, "\r\n\n")
    [first_line | _rest] = String.split(headers, "\r\n")
    [_, code, _] = String.split(first_line, " ")
    code == "200"
  end

  defp start_server(port) do
    spawn(HttpServer, :start, [port])
  end
end
