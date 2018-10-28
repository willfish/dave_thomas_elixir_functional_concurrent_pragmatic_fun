defmodule MyList do
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

orders = [
  [id: 123, ship_to: :NC, net_amount: 100.00],
  [id: 124, ship_to: :OK, net_amount:  35.50],
  [id: 125, ship_to: :TX, net_amount:  24.00],
  [id: 126, ship_to: :TX, net_amount:  44.80],
  [id: 127, ship_to: :NC, net_amount:  25.00],
  [id: 128, ship_to: :MA, net_amount:  10.00],
  [id: 129, ship_to: :CA, net_amount: 102.00],
  [id: 130, ship_to: :NC, net_amount:  50.00]
]

# IO.inspect MyList.calculate_tax(orders)
