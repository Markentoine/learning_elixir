defmodule TextClient.Prompter do
    def ask_guess(game) do
        IO.gets("What is your guess now? : ")
        |> check_input
        |> accept_guess(game)
    end

    defp check_input(:eof, _) do
        IO.puts "Seems like you gave up..."
        exit :normal
    end
    defp check_input({:error, reason }, _) do
        IO.puts "Game ended: #{reason}"
        exit :normal
    end
    defp check_input(input) do
        input = String.trim(input)
        {String.match?(input, ~r/\A[a-z]\z/i), input} || { :error, input }
    end

    defp accept_guess({_good_input = true, input}, game) do
        Map.put(game, :guess, input)
    end
    defp accept_guess({_bad_input, input}, game) do
        ask_guess(game)
    end
end