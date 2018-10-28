defmodule Summing do
  def sum(1) do
    1
  end

  def sum(n) do
    n + sum(n - 1)
  end
end

IO.puts(Summing.sum(90_000))
