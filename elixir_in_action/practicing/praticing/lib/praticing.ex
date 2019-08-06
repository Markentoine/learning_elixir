defmodule Praticing do
  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&(String.length(&1) > 80))
  end

  def line_lengths(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.length/1)
  end
end
