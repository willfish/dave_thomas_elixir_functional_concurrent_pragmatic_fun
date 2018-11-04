defmodule Atmos.Parser do
  @moduledoc """
  XML Parser that parses the response from the weather api
  into a map
  """

  @default_paths ~w[location temp_c latitude longitude]

  def parse(xml, paths \\ @default_paths) do
    xml |> XmlNode.from_string() |> build(paths)
  end

  defp build(doc, paths) do
    append = fn (path, acc) ->
      text = doc |> XmlNode.first(path) |> XmlNode.text()
      Map.put(acc, path, text)
    end

    Enum.reduce(paths, %{}, append)
  end
end
