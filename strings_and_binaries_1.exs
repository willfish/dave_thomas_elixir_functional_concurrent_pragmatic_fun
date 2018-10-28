defmodule Strings do
  def printable?(chars) do
    chars
    |> Enum.all?(&printable_char?/1)
  end

  def printable_char?(char) when char in 32..255, do: true
  def printable_char?(char), do: false
end

IO.inspect Strings.printable?('hello')
IO.inspect Strings.printable?('∂x/∂y')
