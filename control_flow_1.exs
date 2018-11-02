defmodule FizzBuzz do
  def upto(n) when n > 0, do: _upto(1, n, [])

  defp _upto(_current, 0, result), do: Enum.reverse result

  defp _upto(current, left, result) do
    next_answer =
      case {rem(current, 3), rem(current, 5)} do
        {0, 0} ->
          "FizzBuzz"
        {0, _n} ->
          "Fizz"
        {_n, 0} ->
          "Buzz"
        _ ->
          current
      end

    _upto(current + 1, left - 1, [next_answer | result])
  end
end
