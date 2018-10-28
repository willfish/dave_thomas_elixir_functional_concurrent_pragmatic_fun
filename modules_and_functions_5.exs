defmodule GCD do
  def gcd(x, 0), do: x

  def gcd(x, y) do
    gcd(y, rem(x, y))
  end
end


IO.puts GCD.gcd(0, 1)
