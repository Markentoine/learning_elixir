defmodule TryPlugTest do
  use ExUnit.Case
  doctest TryPlug

  test "greets the world" do
    assert TryPlug.hello() == :world
  end
end
