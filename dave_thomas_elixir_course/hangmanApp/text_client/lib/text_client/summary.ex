defmodule TextClient.Summary do
    def display(game = %{ tally: tally}) do
        IO.puts [
            "\n",
            "Word so far: #{Enum.join(tally.letters, " ")}\n",
            "Guesses left: #{tally.turn_left}\n",
            "Already used letters: #{Enum.join(tally.used_letters, ",")}"
        ]
        game
    end
end