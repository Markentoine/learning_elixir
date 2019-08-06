defmodule AutomaticPlayer do
  defdelegate start, to: AutomaticPlayer.Player
end
