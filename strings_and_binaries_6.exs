defmodule Strings do
  def capitalize_sentences(sentences) do
    sentences
    |> String.split(". ")
    |> Enum.map(fn (sentence) -> capitalize_sentence(sentence) end)
    |> Enum.join(". ")
  end

  def capitalize_sentence(sentence) do
    [head | tail] =
      sentence
      |> String.split(" ")

    first =
      head
      |> String.capitalize()
    rest =
      tail
      |> Enum.map(fn (word) -> String.downcase(word) end)

    [first | rest] |> Enum.join(" ")
  end
end

IO.inspect Strings.capitalize_sentences("oh. a DOG. woof. ")
