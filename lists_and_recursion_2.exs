defmodule MyList do
  def caesar([], _n), do: []
  def caesar([head | tail], n), do: [head + n | caesar(tail, n)]
end

