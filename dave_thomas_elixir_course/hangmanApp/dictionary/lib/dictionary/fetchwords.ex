defmodule Dictionary.Fetchwords do

    @me __MODULE__

    def start_link, do: Agent.start_link(&get_words_list/0, name: @me)

    def get_words_list, do: get_words() |> words_list

    defp get_words, do: File.read!(get_path())

    defp words_list(words), do: String.split(words, ~r/\n/)

    defp get_path() do
        "../../assets/words.txt"
        |> Path.expand(__DIR__)
    end
end