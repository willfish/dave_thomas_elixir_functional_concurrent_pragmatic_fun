defmodule Link1 do
  def boom do
    :timer.sleep(500)
    exit(:boom)
  end

  def run do
    spawn_link(__MODULE__, :boom, [])

    receive do
      msg ->
        IO.puts(msg)
    after
      1000 ->
        IO.puts("Nada happened")
    end
  end
end

defmodule Link2 do
  def boom do
    :timer.sleep(500)
    exit(:boom)
  end

  def run do
    Process.flag(:trap_exit, true)
    spawn_link(__MODULE__, :boom, [])

    receive do
      {:EXIT, pid, :boom} ->
        IO.puts("BOOM")

      _ ->
        nil
    after
      1000 ->
        IO.puts("Nada happened")
    end
  end
end
