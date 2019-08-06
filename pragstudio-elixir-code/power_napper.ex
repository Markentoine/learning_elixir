defmodule PowerNapper do
    def power_nap do
        time = :rand.uniform(10_000) 
        :timer.sleep(time)
        time
    end

    def start_nap do
        parent = self()
        spawn(fn -> send(parent, {:slept, power_nap()}) end)
        receive do {:slept, time} -> IO.puts "slept #{time}ms" end
    end
end