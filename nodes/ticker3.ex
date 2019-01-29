defmodule Ring do
  @moduledoc """
  Start a ring of node processes and make them tick
  """

  @node_count 24

  def start_ring do
    # Start all node processes
    nodes =
      node_range()
      |> Enum.map(fn _ -> TickerNode.start() end)

    first_node = Enum.at(nodes, 0)

    chunked_nodes =
      nodes
      |> Enum.chunk_every(2, 1)

    # Link all node processes
    chunked_nodes
    |> Enum.each(fn
      [current_node, next_node] -> TickerNode.update(current_node, next_node)
      [last_node] -> TickerNode.update(last_node, first_node)
    end)

    # Start the ticking
    TickerNode.tick(first_node)

    {:ok, nodes}
  end

  def tick([head | _tail]) do
    TickerNode.tick(head)
  end

  def node_range do
    1..@node_count
  end
end

defmodule TickerNode do
  def loop(next_node) do
    receive do
      :tick ->
        :timer.sleep(2000)
        IO.puts("tick in client #{inspect(self())}")
        send(next_node, :tick)
        loop(next_node)

      {:update_node, new_node} ->
        IO.puts("updated linked node from #{inspect(next_node)} to #{inspect(new_node)}")
        loop(new_node)
    end
  end

  # Client methods
  def start do
    spawn(__MODULE__, :loop, [nil])
  end

  def update(node, next_node) do
    send(node, {:update_node, next_node})
  end

  def tick(node) do
    send(node, :tick)
  end
end
