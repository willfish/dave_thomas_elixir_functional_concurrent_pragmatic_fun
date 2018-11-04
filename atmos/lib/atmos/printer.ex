defmodule Atmos.Printer do
  @moduledoc """
  Prints output in specified format
  """

  def print(data, options \\ %{device: :stdio, format: :table}) do
    formatted = format(data, options.format)
    IO.puts(options.device, formatted)
  end

  def format(data, :json), do: Poison.encode!(data, pretty: true)
  def format(data, :table), do: Scribe.format(data)
end
