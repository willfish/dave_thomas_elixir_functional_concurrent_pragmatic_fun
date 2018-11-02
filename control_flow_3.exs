defmodule Okay do
  def ok!({:ok, data}), do: data
  def oK!(_), do: raise "Raising exception: #{data}"
end
