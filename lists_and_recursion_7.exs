defmodule MyList do
  def span(from, to) when from >= to, do: [from]
  def span(from, to), do: [from | span(from + 1, to)]

  def prime_number?(n) do
    n_divides_into = fn (x) ->
      rem(n, x) == 0
    end

    if n == 1 do
      false
    else
      divisible_by_any =
        2
        |> span(n - 1)
        |> Enum.any?(n_divides_into)

      !divisible_by_any
    end
  end
end

result = for x <- MyList.span(2, 32), MyList.prime_number?(x), do: x

IO.inspect(result)

