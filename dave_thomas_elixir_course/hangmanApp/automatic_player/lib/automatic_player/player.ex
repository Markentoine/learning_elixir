defmodule AutomaticPlayer.Player do
    alias AutomaticPlayer.{State, Think}

    def start do
       Hangman.new_game()
       |> set_up
       |> Think.find_best_guess
       |> play
    end

    #### PRIVATE ####

    defp set_up(game) do
        %State{
            game_service: game,
            tally: Hangman.tally(game),
        }
    end

    defp request_move(game, guess) do
        {game_service, tally} = Hangman.request_move(game, guess)
        %State{game_service: game_service, tally: tally}
    end

    defp play({game =%State{tally: %{game_state: :initializing}}, guesses}) do
        continue_with_message("Welcome in the game!", {game, guesses})
    end

    defp play({%State{tally: %{game_state: :won}}, _guesses}) do
        exit_with_message("AI won!!!")
    end

    defp play({%State{tally: %{game_state: :lost}}, _guesses}) do
        exit_with_message("Yes, it's possible: AI lost!")
    end

    defp play({game = %State{tally: %{game_state: :good_guess}}, guesses}) do
        continue_with_message("AI made a good guess!", {game, guesses})
    end
    
    defp play({game = %State{tally: %{game_state: :bad_guess}}, guesses}) do
        continue_with_message("This guess was bad!", {game, guesses})
    end

    defp play(infos) do
        continue(infos)
    end

    defp exit_with_message(msg) do
        IO.puts msg
        Process.sleep(1000)
        exit(:normal)
    end
    
    defp continue_with_message(msg, infos) do
        IO.puts msg
        Process.sleep(1000)
        continue(infos)
    end

    defp continue({game, [{best_guess, _freq} | next]}) do
        %State{game_service: gs, tally: tally} = game
        IO.puts Enum.join(tally.letters, " ")
        IO.puts "Turn left: #{tally.turn_left}"
        IO.puts "AI guess: #{best_guess}"
        game = request_move(gs, best_guess)
        play({game, next})
    end
end