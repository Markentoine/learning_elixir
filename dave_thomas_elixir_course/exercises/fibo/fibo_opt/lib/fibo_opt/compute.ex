defmodule FiboOpt.Compute do

    def fibo(n) do
        {:ok, cacheID} = Cache.start()
         result = find_result(cacheID, n)
         Agent.stop(cacheID)
         result
    end

    defp find_result(cacheID, n) do
        check_value(cacheID, n)
        |> compute_result(cacheID, n)
        |> update_and_get
    end

    defp check_value(pid, n), do: Cache.get(pid, n)

    defp compute_result(_value_not_exists = nil, pid, n) do
        value = find_result(pid, n - 2) + find_result(pid, n - 1)
        {value, pid, n, :update}
    end

    defp compute_result(value, pid, n), do: {value, pid, n, :no_update}

    defp update_and_get({value, pid, n, :update}) do
         Cache.add(pid, n, value)
         value
    end

    defp update_and_get({value, _, _, :no_update}), do: value
end