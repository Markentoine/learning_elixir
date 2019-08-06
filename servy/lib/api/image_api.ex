defmodule Servy.Api.ImageApi do
  def query(conv, id) do
    api_address =
      "https://api.myjson.com/bins/#{id}"
      |> HTTPoison.get()
      |> handle_fetching_url_address
      |> generate_response(conv)
  end

  defp handle_fetching_url_address({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    body_map = Poison.Parser.parse!(body, %{})
    {:ok, get_in(body_map, ["image", "image_url"]), 200}
  end

  defp handle_fetching_url_address({:ok, %HTTPoison.Response{status_code: status, body: body}}) do
    body_map = Poison.Parser.parse!(body, %{})
    {:ok, body_map["message"], status}
  end

  defp handle_fetching_url_address({:error, error}) do
    error_map = Poison.Parser.parse!(error, %{})
    {:error, error_map["reason"]}
  end

  defp generate_response({:ok, body, status}, conv) do
    %{conv | status: status, resp_body: body}
  end

  defp generate_response({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "Whoops! #{reason}"}
  end
end
