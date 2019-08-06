defmodule Geom do
    @moduledoc """
    Provides some functions to compute geometric area.
    """
    @doc """
    Compute the area of a rectangle given the length and the width.
    Default arguments have each the value 1.
    """
    @spec area(number(), number()) :: number()

    def area({shape, a, b}), do: area(shape, a, b)
    defp area(:rectangle, len \\ 1, wid \\1) when len>= 0 and wid >= 0, do: len * wid
    defp area(:triangle, base, hauteur) when base>= 0 and hauteur >= 0, do: (base * hauteur) / 2
    defp area(:ellipse, radius1, radius2) when radius1 >= 0 and radius2 >= 0, do: (radius1 * radius2) * :math.pi()
    defp area(_shape, len, wid) when len>= 0 and wid >= 0, do: len * wid
    defp area(_shape, _len, _wid), do: :error
    
    def sum( a \\ 3, b, c \\ 7) do
        a + b + c
    end
end