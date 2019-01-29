defmodule Boom do
  import :timer, only: [sleep: 1]

  def sad_function do
    sleep(500)
    exit(:boom)
  end

  def run do
    spawn(Boom, :sad_function, [])

    receive do
      msg ->
        IO.puts("Received: #{inspect(msg)}")
    after
      1000 ->
        IO.puts("Nothing happened dude")
    end
  end
end
