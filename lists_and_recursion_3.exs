defmodule MyList do
  def max([head | tail]) do
    aux(tail, head)
  end

  defp aux([], memo), do: memo
  defp aux([head | []], memo) when head >= memo, do: head
  defp aux([head | []], memo), do: memo
  defp aux([head | tail], memo) when memo >= head, do: aux(tail, memo)
  defp aux([head | tail], memo), do: aux(tail, head)
end

