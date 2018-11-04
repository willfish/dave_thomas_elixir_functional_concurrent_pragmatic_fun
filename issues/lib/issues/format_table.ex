defmodule Issues.FormatTable do
  @moduledoc """
  Format issue fields as a table
  """

  @row_separator " | "
  @separator_separator "-+-"

  # Generate max column_widths for each header
  # Print formatted header line
  # Print formatted separator line
  # Walk and print formatted row lines
  # Assume width of header is shorter than value!
  def format(issues, headers) do
    with column_widths = generate_column_widths(issues, headers),
         formatted_headers = format_headers(headers, column_widths),
         formatted_separator = format_separator(headers, column_widths),
         formatted_rows = format_rows(issues, headers, column_widths)
    do
      {:ok, device} = StringIO.open("")

      IO.puts(device, formatted_headers)
      IO.puts(device, formatted_separator)

      for formatted_row <- formatted_rows do
        IO.puts(device, formatted_row)
      end

      table = StringIO.flush(device)
      StringIO.close(device)
      IO.puts table
      table
    end
  end

  defp generate_column_widths(issues, headers) do
    widths = column_widths(issues, headers)
    indexed_headers = Enum.with_index(headers)

    for {header, index} <- indexed_headers, into: %{} do
      max = widths |> Enum.at(index) |> Enum.max()
      {header, max}
    end
  end

  defp format_headers(headers, column_widths) do
    row = for header <- headers do
      column_width = Map.get(column_widths, header)

      String.pad_trailing(header, column_width)
    end

    Enum.join(row, @row_separator)
  end

  defp format_separator(headers, column_widths) do
    row = for header <- headers do
      column_width = Map.get(column_widths, header)

      String.duplicate("-", column_width)
    end

    Enum.join(row, @separator_separator)
  end

  defp format_rows(issues, headers, column_widths) do
    for issue <- issues, do: format_row(issue, headers, column_widths)
  end

  defp format_row(issue, headers, column_widths) do
    row = for header <- headers  do
      value = extract_value(issue, header)
      column_width = Map.get(column_widths, header)

      String.pad_trailing(value, column_width)
    end

    Enum.join(row, @row_separator)
  end

  defp column_widths(issues, headers) do
    for header <- headers do
      for issue <- issues do
        extract_width(issue, header)
      end
    end
  end

  defp extract_width(issue, header) do
    issue
    |> extract_value(header)
    |> String.length()
  end

  defp extract_value(issue, header) do
    with value = Map.get(issue, header),
         value = normalize_value(value)
    do
      value
    end
  end

  defp normalize_value(value) when is_float(value), do: Float.to_string(value)
  defp normalize_value(value) when is_integer(value), do: Integer.to_string(value)
  defp normalize_value(value), do: value
end
