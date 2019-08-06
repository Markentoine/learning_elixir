defmodule AutomaticPlayer.Think do

    alias AutomaticPlayer.State

    def find_best_guess(game = %State{tally: tally}) do
        best_guesses = Dictionary.n_length_words(tally.word_length)
        |> compute_frequencies(tally)
        {game, best_guesses}
    end

    def compute_frequencies(words, tally) do
        total_letters = length(words) * tally.word_length
        words
        |> letters_distribution
        |> letters_frequencies(total_letters)
        |> sort_by_frequencies
    end

    defp increment_value(letter, acc, _already_counted = nil) do
        Map.put(acc, letter, 1)
    end
    defp increment_value(letter, acc, count) do
        Map.put(acc, letter, count + 1)
    end
    defp letters_distribution(words) do
        Enum.reduce(words, Map.new(), fn word, acc -> 
            letters = String.codepoints(word)
            Enum.reduce(letters, acc, fn letter, res ->
                increment_value(letter, res, Map.get(res, letter))
            end)
        end)
    end

    defp letters_frequencies(distribution, total_letters) do
        Enum.reduce(distribution, %{}, fn {letter, n}, acc -> 
            Map.put(acc, letter, n / total_letters)
        end)
    end

    defp sort_by_frequencies(frequencies) do
        Enum.sort_by(frequencies, fn {letter, freq} -> 1/freq end)
    end
end