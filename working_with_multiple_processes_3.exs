defmodule Link1 do
  def sad_function(parent) do
    IO.inspect("[CHILD] Sending message")
    send(parent, {:ok, "wtf"})
    IO.inspect("[CHILD] Exiting")
    exit(:boom)
  end

  def run() do
    IO.inspect("[PARENT] Spawning link")
    spawn_link(__MODULE__, :sad_function, [self])
    IO.inspect("[PARENT] Sleeping")
    :timer.sleep(500)
    IO.inspect("Receiving messages")

    receive do
      msg -> IO.inspect(msg)
    end
  end
end

Link1.run()
