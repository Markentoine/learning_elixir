defmodule Cache do
  defdelegate start, to: Cache.Access
  defdelegate get(pid, n), to:  Cache.Access
  defdelegate add(add, key, value), to:  Cache.Access
end
