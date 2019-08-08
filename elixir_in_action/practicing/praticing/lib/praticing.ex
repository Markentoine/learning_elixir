defmodule Praticing do
  def give_path do
    Path.expand("../../../../dave_thomas_elixir_course/hangmanApp/dictionary/assets/words.txt", __DIR__)
  end
  
  def large_lines!(path) do
    give_path()
    |> File.stream!
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&(String.length(&1) > 80))
  end

  def line_lengths!(n) do
    give_path()
    |> File.stream!
    |> Stream.map(&String.length/1)
    |> Enum.take(n)
  end

  def longest_line_length! do
    give_path()
    |> File.stream!
    |> Stream.map(&String.length/1)
    |> Enum.max
  end

  def longest_line do
    line = give_path()
    |> File.stream!
    |> Stream.map(&String.trim/1)
    |> Stream.map(&%{"line"=> &1, "len"=>:string.length(&1)})
    |> Enum.reduce(%{"line"=> "", "len"=> 0},fn x, acc -> 
      cond do
        x["len"] > acc["len"] -> x
        true -> acc
      end
    end)
    line["line"]
  end
end
