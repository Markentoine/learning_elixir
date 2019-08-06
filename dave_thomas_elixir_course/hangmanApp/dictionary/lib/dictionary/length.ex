defmodule Dictionary.Length do

    alias Dictionary.Fetchwords

    def get_words_length(n) do
        Fetchwords.get_words
        |> Fetchwords.words_list
        |> select_words_length(n)
    end

    defp select_words_length(words, n) do
        Enum.filter(words, &(String.length(&1) == n))
    end
end