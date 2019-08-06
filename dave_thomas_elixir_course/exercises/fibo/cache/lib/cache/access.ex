defmodule Cache.Access do
    def start do
        Agent.start_link(fn -> %{0 => 0, 1 => 1} end)
    end

    def get(agentID, n) do
        Agent.get(agentID, fn cache -> cache[n] end)
    end

    def add(agentID, n, value) do
        Agent.update(agentID, fn cache -> Map.put(cache, n, value) end )
    end
end