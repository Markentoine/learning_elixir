defmodule Salary do
    def getDetails do
        income = IO.gets("What is your income?")
        parsed_income = Integer.parse(income)
        case parsed_income do
            :error -> IO.puts("Invalid income")
            {income, _} -> 
            tax = income_tax(income)
            wage = income - tax
            IO.puts("Your wage is: #{wage} and tax: #{tax}")
        end
    end

    defp income_tax(income) when income <= 2000, do: 0
    defp income_tax(income) when income <= 3000, do: income * 0.05
    defp income_tax(income) when income <= 6000, do: income * 0.10
    defp income_tax(income) when income > 6000, do: income * 0.15
end