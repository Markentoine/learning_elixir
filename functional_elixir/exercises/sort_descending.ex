defmodule Sort do

    def descending([a]), do: [a]
    def descending([]), do: []
    def descending(list) do
        count = Enum.count(list)
        half = div(count, 2)
        {list1, list2} = Enum.split(list, half)
        merge(descending(list1), descending(list2))
    end

    defp merge(list, []), do: list
    defp merge([], list), do: list 
    defp merge([head1 | tail1], list = [head2 | _]) when head1 >= head2, do: concatList([head1], merge(tail1, list))
    defp merge(list = [head1 | _], [head2 | tail2]) when head1 < head2, do: concatList([head2], merge(list, tail2))

    defp concatList(list1, list2), do: list1 ++ list2

end