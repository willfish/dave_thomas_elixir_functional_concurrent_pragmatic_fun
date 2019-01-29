defmodule Monitor1 do
  def boom do
    :timer.sleep(500)
    exit(:boom)
  end

  def run do
    res = spawn_monitor(__MODULE__, :boom, [])
    IO.puts(inspect(res))

    receive do
      msg ->
        IO.puts("Received #{inspect(msg)}")
    after
      1000 ->
        IO.puts("Nothing")
    end
  end
end
