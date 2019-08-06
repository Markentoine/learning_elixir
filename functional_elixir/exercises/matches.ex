defmodule MatchstickFactory do
    def boxes(number) do
        big = div(number, 50)
        rem1 = rem(number, 50)
        medium = div(rem1, 20)
        rem2 = rem(rem1, 20)
        small = div(rem2, 5)
        remaining = rem(rem2, 5)
        %{"big" => big, medium: medium, small: small, remaining_matches: remaining}
    end
end