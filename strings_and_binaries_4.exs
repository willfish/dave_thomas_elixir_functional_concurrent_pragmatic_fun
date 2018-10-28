defmodule Strings do
  @number_chars 48..57
  @operator_chars [42, 43, 45, 47]
  @default_ast %{
    left_operand: '',
    right_operand: '',
    operator: nil
  }

  def calculate(operation) do
    operation
    |> parse(@default_ast)
    |> normalise()
    |> execute()
  end

  defp parse([], acc), do: acc

  defp parse([head | tail], acc) when head in @number_chars do
    acc = if Map.get(acc, :operator) do
      right_operand = Map.get(acc, :right_operand)
      %{acc | right_operand: [head | right_operand]}
    else
      left_operand = Map.get(acc, :left_operand)
      %{acc | left_operand: [head | left_operand]}
    end

    parse(tail, acc)
  end

  defp parse([head | tail], acc) when head in @operator_chars do
    parse(tail, %{acc | operator: head})
  end

  defp parse([head | tail], acc), do: parse(tail, acc)

  defp normalise(%{left_operand: l, right_operand: r, operator: o}) do
    %{
      left_operand: normalise(l),
      right_operand: normalise(r),
      operator: o
    }
  end

  defp normalise(chars) do
    chars
    |> Enum.reverse()
    |> List.to_integer()
  end

  defp execute(%{left_operand: left, right_operand: right, operator: ?+}), do: left + right
  defp execute(%{left_operand: left, right_operand: right, operator: ?*}), do: left * right
  defp execute(%{left_operand: left, right_operand: right, operator: ?/}), do: left / right
  defp execute(%{left_operand: left, right_operand: right, operator: ?-}), do: left - right
end

IO.inspect Strings.calculate('123 + 27') # => 150
IO.inspect Strings.calculate('177- 27') # => 150
IO.inspect Strings.calculate('1500 /10') # => 150
IO.inspect Strings.calculate('15*10') # => 150
