defmodule Patterns do
    def swap({a, b}), do: {b, a}
    def sameP(a, a), do: :true
    def sameP(_, _), do: :false
    def map([], _func), do: []
    def map([h|t], func), do: [ func.(h) | map(t, func) ]
end