defmodule Chop do
  def guess(0, _), do: 0

  def guess(answer, first..last) do
    range = last - first
    middle = first + div(range, 2)

    check_middle(middle, answer, first, last)
  end

  defp check_middle(middle, answer, first, last) when middle == answer do
    middle
  end

  defp check_middle(middle, answer, first, last) when middle < answer do
    first = middle + 1
    guess(answer, first..last)
  end

  defp check_middle(middle, answer, first, last) when middle > answer do
    last = middle - 1
    guess(answer, first..last)
  end
end

# Enum.map(0..1000,
#   fn (n) ->
#     IO.puts Chop.guess(n, 1..1000)
#   end
# )

IO.puts Chop.guess(275, 1..1000)
IO.puts Chop.guess(274, 1..1000)
IO.puts Chop.guess(272, 1..1000)
IO.puts Chop.guess(271, 1..1000)
