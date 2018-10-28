defmodule Strings do
  def anagram?(anagram, word) when length(anagram) == length(word) do
    anagram = Enum.sort(anagram)
    word = Enum.sort(word)

    anagram == word
  end

  def anagram?(_anagram, _word), do: false
end


IO.inspect Strings.anagram?('elloh', 'hello')
IO.inspect Strings.anagram?('eloh', 'hello')
IO.inspect Strings.anagram?('ieloh', 'hello')
