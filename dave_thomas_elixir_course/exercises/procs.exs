defmodule Procs do
    def greeter(count) do
        receive do
            {:add, n} -> greeter(add(n, count))
            {:reset} -> greeter(0)
            msg -> IO.puts "#{count}: Hello #{msg}!!!"
        end
        greeter(count)
    end

    defp add(n, count), do: count + n
end