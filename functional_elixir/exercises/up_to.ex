defmodule Sum do
    def upto(n) when n < 0, do: :error
    def upto(0), do: 0
    def upto(n) do
        add(upto(n - 1), n)
    end

    def sum([]), do: 0
    def sum([head | tail]) do
        add(head, sum(tail))
    end

    defp add(a, b), do: a + b 
end