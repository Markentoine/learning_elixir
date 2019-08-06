defmodule TextClient.Mover do
    alias TextClient.State

    def request_move(game) do
        tally = Hangman.request_move(game.game_service, game.guess)
        %State{ game | tally: tally }
    end
end
