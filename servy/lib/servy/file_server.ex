defmodule Servy.FileServer do
  require Logger

  @pages_path Path.expand("pages", File.cwd!())

  alias Servy.FileHandler

  def serve_file(conv, file_name) do
    Path.join([@pages_path, "#{file_name}"])
    |> File.read()
    |> FileHandler.handle_file(conv)
  end

  def serve_file_bis(conv, file_name) do
    path_to_file = Path.join([@pages_path, file_name])

    case File.read(path_to_file) do
      {:ok, content} ->
        %{conv | status: 209, resp_body: content}

      {:error, :enoent} ->
        Logger.warn("File Not Found")
        conv
    end
  end
end
