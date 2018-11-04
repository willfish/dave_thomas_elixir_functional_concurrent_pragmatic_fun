defmodule AtmosTest do
  use ExUnit.Case
  doctest Atmos

  test "greets the world" do
    assert Atmos.hello() == :world
  end
end
