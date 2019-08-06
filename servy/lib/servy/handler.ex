defmodule Servy.Handler do
  require Logger

  alias Servy.{Plugins, Parser, FileServer, Conv, Controller, VideoCam, Api, Tracker, ViewSensors}

  @moduledoc """
    Handles HTTP requests
  """

  @doc """
    Process the request to output a response.
  """
  def handle(request) do
    request
    |> Parser.parse()
    |> Plugins.rewrite_path()
    |> route
    |> Plugins.track()
    |> format_response
  end

  defp route(%Conv{method: "GET", path: "/pledges"} = conv) do
    Servy.PledgeController.index(conv)
  end

  defp route(%Conv{method: "POST", path: "/pledges"} = conv) do
    Servy.PledgeController.create(conv, conv.params)
  end

  defp route(%Conv{method: "GET", path: "/kaboom"} = conv) do
    raise "kaboom!!!"
  end

  defp route(%Conv{method: "GET", path: "/api/image/" <> id} = conv) do
    Api.ImageApi.query(conv, id)
  end

  defp route(%Conv{method: "GET", path: "/sensors"} = conv) do
    # to see Task under the hood, see Fetcher
    task = Task.async(Servy.Tracker, :get_location, ["roscoe"])

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    coord_roscoe = Task.await(task)

    %{conv | status: 200, resp_body: ViewSensors.render({snapshots, coord_roscoe})}
  end

  defp route(%Conv{method: "GET", path: "/languages"} = conv) do
    Controller.index(conv)
  end

  defp route(%Conv{method: "GET", path: "/languages/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    Controller.show(conv, params)
  end

  defp route(%Conv{method: "GET", path: "/frameworks"} = conv) do
    %{conv | status: 200, resp_body: "Phoenix, React, Rails"}
  end

  defp route(%Conv{method: "GET", path: "/api/languages"} = conv) do
    Api.LanguagesController.index(conv)
  end

  defp route(%Conv{method: "POST", path: "/api/languages"} = conv) do
    Api.LanguagesController.create_language(conv)
  end

  defp route(%Conv{method: "GET", path: "/about"} = conv) do
    FileServer.serve_file(conv, "about.html")
  end

  defp route(%Conv{method: "GET", path: "/language/new"} = conv) do
    FileServer.serve_file_bis(conv, "form.html")
  end

  defp route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    FileServer.serve_file(conv, "#{file}.html")
  end

  defp route(%Conv{method: "POST"} = conv) do
    Controller.create(conv, conv.params)
  end

  defp route(%Conv{method: "DELETE"} = conv) do
    Controller.delete(conv)
  end

  defp route(%Conv{} = conv) do
    Servy.FourOhFourCounter.bump_count(conv.path)
    %{conv | status: 404}
  end

  # a way to better type safety check-> we want only Conv struct to be passed in the method
  defp format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}\r
    Content-Type: #{conv.header_content_type}\r
    Content-Length: #{byte_size(conv.resp_body)}\r

    #{conv.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      204 => "No Content",
      201 => "Created",
      209 => "File Served",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
  end
end
