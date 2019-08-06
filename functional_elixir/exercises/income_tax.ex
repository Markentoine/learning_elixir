defmodule Tax do
    def income_tax(income) do
        result = cond do
            income <= 2000 -> 0
            income <= 3000 -> income * 0.05
            income <= 6000 -> income * 0.10
            income > 6000 -> income * 0.15
        end
        result
    end

    def income_tax2(income) when income <= 2000, do: 0
    def income_tax2(income) when income <= 3000, do: income * 0.05
    def income_tax2(income) when income <= 6000, do: income * 0.10
    def income_tax2(income) when income > 6000, do: income * 0.15
end