defmodule Servy.Parser do
  alias Servy.Conv

  def parse(request) do
    [head, params_line] = String.split(request, "\r\n\r\n")
    [first_line | headers_lines] = String.split(head, "\r\n")
    [method, path, _] = first_line |> String.trim() |> String.split(" ")
    headers = parse_headers(headers_lines)
    params = parse_params(headers["Content-Type"], params_line)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_params("application/x-www-form-urlencoded", params_string) do
    URI.decode_query(params_string)
  end

  def parse_params("application/json", params_string) do
    Poison.Parser.parse!(params_string, %{})
  end

  def parse_params(_, _), do: %{}

  def parse_headers(lines) do
    parse_headers(%{}, lines)
  end

  def parse_headers(conv, []), do: conv

  def parse_headers(conv, lines) do
    [first_line | rest] = lines
    [key, value] = String.split(first_line, ": ")
    new_conv = Map.put(conv, String.trim(key), String.trim(value))
    parse_headers(new_conv, rest)
  end
end
