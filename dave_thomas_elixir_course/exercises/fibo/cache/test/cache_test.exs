defmodule CacheTest do
  use ExUnit.Case
  doctest Cache

  test "get a value from cache" do
    {:ok, pid} = Cache.start()
    assert Cache.get(pid, 0) == 0
    assert Cache.get(pid, 1) == 1
  end

  test "store a value in cache" do
    {:ok, pid} = Cache.start()
    Cache.add(pid, 2, 1)
    assert Cache.get(pid, 2) == 1
  end
end
