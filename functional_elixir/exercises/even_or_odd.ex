defmodule EvenOrOdd do
    require Integer #necessary to use the macros is_even, is_odd

    def check(number) when Integer.is_even(number), do: 'even'
    def check(number) when Integer.is_odd(number), do: 'odd'
end