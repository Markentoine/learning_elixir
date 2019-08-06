defmodule TextClient.Player do
    alias TextClient.{State, Summary, Prompter, Mover}

    def play(game = %State{ tally: %{ game_state: :initializing}}) do
        continue_with_message(game, "Welcome! Let's play!")
    end
    def play(game = %State{ tally: %{ game_state: :already_used}}) do
        continue_with_message(game, "You have already used this letter!")
    end
    def play(game = %State{ tally: %{ game_state: :good_guess}}) do
        continue_with_message(game, "Cool! You found a letter!")
    end
    def play(game = %State{ tally: %{ game_state: :bad_guess}}) do
        continue_with_message(game, "Oops! This one is not in the word...")
    end
    def play(%State{ tally: %{ game_state: :won}}) do
        exit_with_message("Bravo! You won!")
    end
    def play(%State{ tally: %{ game_state: :lost}}) do
        exit_with_message("Sorry! You lost!")
    end
    def play(game), do: continue(game)
    
    defp exit_with_message(msg) do
        IO.puts msg
        exit(:normal)
    end

    defp continue_with_message(game, msg) do
        IO.puts msg
        continue(game)
    end

    defp continue(game) do
        game
        |> Summary.display
        |> Prompter.ask_guess
        |> Mover.request_move
        |> play
    end

end