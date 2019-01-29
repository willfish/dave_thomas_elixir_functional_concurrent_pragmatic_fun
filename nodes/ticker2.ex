defmodule Ticker do
  @moduledoc """
  Stores a list of processes and messages nodes on an interval
  by sendimg them a tick message in order.
  """

  @interval 2000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], 0])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send(:global.whereis_name(@name), {:register, client_pid})
  end

  def generator(clients, index) do
    receive do
      {:register, pid} ->
        IO.puts("registering #{inspect(pid)}")
        generator([pid | clients], index)
    after
      @interval ->
        IO.puts("tick")
        IO.inspect(clients)

        new_index = tick_client(clients, index)
        IO.puts(new_index)
        generator(clients, new_index)
    end
  end

  def tick_client([], _), do: 0

  def tick_client(clients, index) do
    clients
    |> Enum.at(index)
    |> send({:tick})

    new_index = index + 1
    max_index = length(clients) - 1

    if max_index < new_index do
      0
    else
      new_index
    end
  end
end

defmodule Client do
  @moduledoc """
  Client registers with the ticker on start and after an interval it receives a tick
  The client can be run from any node in a cluster as we use a register to store information
  on our node client process.
  """

  def start do
    pid = spawn(__MODULE__, :receiver, [])
    Ticker.register(pid)
  end

  def receiver do
    receive do
      {:tick} ->
        IO.puts("tock in client")
        receiver()
    end
  end
end
