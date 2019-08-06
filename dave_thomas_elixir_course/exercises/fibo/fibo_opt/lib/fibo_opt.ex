defmodule FiboOpt do
  defdelegate fibo(n), to: FiboOpt.Compute
end
