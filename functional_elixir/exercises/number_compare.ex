defmodule NumberCompare do
    def greater(number, other_number) do
        check(number>=other_number, number, other_number)
    end

    defp check(true, number, _), do: number #use pattern matching to assign the value of number to the local var number and, affter assignment, returns it
    defp check(false, _, other_number), do: other_number
end