defmodule Timer do
    def remind(todo, time) do
        spawn(fn -> :timer.sleep(time * 1000); IO.puts todo end)
    end
end