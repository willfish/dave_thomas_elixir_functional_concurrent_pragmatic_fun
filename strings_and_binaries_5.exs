defmodule Strings do
  def center(collection) do
    max_length = maximum(collection)

    collection
    |> Enum.reduce("", fn (word, acc) ->
      acc <> justify(word, max_length) <> "\n"
    end)
  end

  defp maximum(collection) do
    collection
    |> Enum.max_by(fn (string) -> String.length(string) end)
    |> String.length()
  end

  defp justify(word, max) do
    length = String.length(word)

    range = max - String.length(word)
    padding = trunc(range / 2)
    word
    |> String.pad_leading(length + padding)
    |> String.pad_trailing(max)
  end
end

IO.puts Strings.center(["cat", "zebra", "elephant", "monkey", "elephant", "crocodiles"])
