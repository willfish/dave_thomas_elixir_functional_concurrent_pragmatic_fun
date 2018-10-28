defmodule MyList do
  def all?([], _fun), do: "What you talkin' about Willis"

  def all?([head | tail], fun) do
    !!reduce(tail, fun.(head), fn (x, acc) ->
      cond do
        acc == false -> false
        true -> fun.(x)
      end
    end)
  end

  def each([], fun), do: nil

  def each([head | tail], fun) do
    fun.(head)
    each(tail, fun)
  end

  def filter(list, fun) do
    reduce(list, [], fn (x, acc) ->
      cond do
        fun.(x) -> acc ++ [x]
        true -> acc
      end
    end)
  end

  def split([], fun), do: []

  def split(list, count) do
    {answer, size} = reduce(list, {[[],[]], 1}, fn (x, {[list_a, list_b], n}) ->
      new_n = n + 1
      cond do
        n <= count -> {[list_a ++ [x], list_b], new_n}
        true -> {[list_a, list_b ++ [x]], new_n}
      end
    end)

    answer
  end

  def take(list, count) do
    {answer, size} = reduce(list, {[], 1}, fn (x, {acc, n}) ->
      new_n = n + 1
      cond do
        n <= count -> {acc ++ [x], new_n}
        true -> {acc, new_n}
      end
    end)

    answer
  end

  def reduce([], acc, _fun), do: acc

  def reduce([head | tail], acc, fun) do
    reduce(tail, fun.(head, acc), fun)
  end
end

divisible_by_2 = &(rem(&1, 2) == 0)

list = [1,2,3,4]
IO.inspect(MyList.all?(list, divisible_by_2))

list = [2,4]
IO.inspect(MyList.all?(list, divisible_by_2))

list = []
IO.inspect(MyList.all?(list, divisible_by_2))

list = ["hello", "world"]
inspect_me = &(IO.inspect(&1))

MyList.each(list, inspect_me)

list = [1,2,3,4]
IO.inspect(MyList.filter(list, divisible_by_2))

list = [1,2,3,4]
IO.inspect(MyList.split(list, 3))

list = [1,2,3,4]
IO.inspect(MyList.take(list, 3))
