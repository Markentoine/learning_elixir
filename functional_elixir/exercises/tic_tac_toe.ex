defmodule TicTacToe do
    def winner({x, x, x,
                _ , _, _,
                _, _, _}), do: {:winner, x}
    def winner({_, _, _,
                x, x, x,
                _, _, _}), do: {:winner, x}
    def winner({_, _, _,
                _, _, _,
                x, x, x}), do: {:winner, x}
    def winner({x, _, _,
                x, _, _,
                x, _, _}), do: {:winner, x}
    def winner({_, x, _,
                _, x, _,
                _, x, _}), do: {:winner, x}
    def winner({_, _, x,
                _, _, x,
                _, _, x}), do: {:winner, x}
    def winner({x, _, _,
                _, x, _,
                _, _, x}), do: {:winner, x}
    def winner({_, _, x,
                _, x, _,
                x, _, _}), do: {:winner, x}
    def winner(_board), do: :no_winner
end