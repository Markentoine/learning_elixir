defmodule HighOderFunctions do
    def compose(f, g) do
        fn arg -> f.(g.(arg)) end
    end
end