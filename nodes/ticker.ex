defmodule Ticker do
  @moduledoc """
  Stores a list of processes via recursion and messages nodes on an interval
  by sendimg them a tick message.
  """

  @interval 2000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[]])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    send(:global.whereis_name(@name), {:register, client_pid})
  end

  def generator(clients) do
    receive do
      {:register, pid} ->
        IO.puts("registering #{inspect(pid)}")
        generator([pid | clients])
    after
      @interval ->
        IO.puts("tick")

        clients
        |> Enum.each(fn client -> send(client, {:tick}) end)

        generator(clients)
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
