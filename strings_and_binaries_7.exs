defmodule TaxCalculator do
  @north_carolina_tax_rate 0.075
  @texas_tax_rate 0.08
  @no_tax_rate 0.0

  def calculate_tax(orders) do
    for order <- orders, do: [total_amount_for(order) | order]
  end

  defp total_amount_for([_,{:ship_to, :NC},{:net_amount, net}]) do
    net
    |> tax_at(@north_carolina_tax_rate)
    |> total_amount()
  end

  defp total_amount_for([_,{:ship_to, :TX},{:net_amount, net}]) do
    net
    |> tax_at(@texas_tax_rate)
    |> total_amount()
  end

  defp total_amount_for([_,{:ship_to, _},{:net_amount, net}]) do
    net
    |> tax_at(@no_tax_rate)
    |> total_amount()
  end

  defp total_amount(total) do
    {:total_amount, total}
  end

  defp tax_at(net, tax_rate) do
    tax = net * tax_rate
    net + tax
  end
end

defmodule TaxCSVParser do
  @orders_file "strings_and_binaries_7.csv"
  @header "id,ship_to,net_amount\n"

  def parse() do
    @orders_file
    |> stream_file()
    |> parse_lines()
    |> calculate_tax()
  end

  defp stream_file(file), do: File.stream!(file)

  defp parse_lines(lines) do
    lines
    |> reject_header()
    |> Enum.map(&parse_line/1)
  end

  defp calculate_tax(orders) do
    TaxCalculator.calculate_tax(orders)
  end

  defp reject_header(stream) do
    Enum.reject(stream, fn (line) -> line == @header end)
  end

  defp parse_line(line) do
    line
    |> split_line()
    |> normalize_line()
    |> convert_to_keyword_list()
  end

  defp split_line(line), do: String.split(line, ",")

  defp normalize_line([id, ship_to, net_amount]) do
    id = String.to_integer(id)
    ship_to =
      ship_to
      |> String.replace(":", "")
      |> String.to_atom()
    net_amount =
      net_amount
      |> String.trim()
      |> String.to_float()

    [id, ship_to, net_amount]
  end

  defp convert_to_keyword_list([id, ship_to, net_amount]) do
    [id: id, ship_to: ship_to, net_amount: net_amount]
  end
end

IO.inspect(TaxCSVParser.parse())
