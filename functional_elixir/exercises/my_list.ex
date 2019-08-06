defmodule MyList do
    def maxL([head | []], current_max) do
        checkMax(head, current_max)
    end
    def maxL([head | tail]) do
        current_max = head  
        maxL(tail, checkMax(head, current_max))
    end
    def maxL([head | tail], current_max) do
        maxL(tail, checkMax(head, current_max))
    end

    def minL([head | []], current_min) do
        checkMin(head, current_min)
    end
    def minL([head | tail]) do
        current_min = head
        minL(tail, checkMin(head, current_min))
    end
    def minL([head | tail], current_min) do
        minL(tail, checkMin(head, current_min))
    end

    defp checkMax(x, y) when x >= y, do: x
    defp checkMax(x, y) when x < y, do: y

    defp checkMin(x, y) when x <= y, do: x
    defp checkMin(x, y) when x > y, do: y
    

end