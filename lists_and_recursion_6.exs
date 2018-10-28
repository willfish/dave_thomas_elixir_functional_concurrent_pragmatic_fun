defmodule MyList do
  def flatten([]), do: []

  def flatten(list) do
    flatten(list, [])
  end

  # When the head of the list is a list recurse through it extracting it's values into an accumulator
  # When the head of the list is not a list append it to the accumulator
  def flatten(list, acc) do
    reduce(list, [], fn (head, acc) ->
      cond do
        is_list(head) -> acc ++ flatten(head, acc)
        true -> acc ++ [head]
      end
    end)
  end

  def reduce([], acc, _fun), do: acc

  def reduce([head | tail], acc, fun) do
    reduce(tail, fun.(head, acc), fun)
  end
end

example_1 = [] # []
example_2 = [1, 2, 3, 4] # [1, 2, 3, 4]
example_3 = [1, [1, [5,6,7,8], 2,3,4], 2, 3, 4] # [1, 1, 5, 6, 7, 8, 2, 3, 4, 2, 3, 4]


IO.inspect(MyList.flatten(example_1))
IO.inspect(MyList.flatten(example_2))
IO.inspect(MyList.flatten(example_3))
IO.inspect(MyList.flatten([ 1, [ 2, 3, [4] ], 5, [[[6]]]]))
