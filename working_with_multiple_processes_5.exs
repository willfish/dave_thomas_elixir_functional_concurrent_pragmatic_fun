defmodule Monitor1 do
  def sad_function(parent) do
    IO.inspect("[CHILD] Sending message")
    IO.inspect("[CHILD] Exiting")
    exit(:child_boom)
  end

  def run() do
    IO.inspect("[PARENT] Spawning link")
    spawn_monitor(__MODULE__, :sad_function, [self])
    IO.inspect("[PARENT] Sleeping")
    :timer.sleep(500)
    IO.inspect("Receiving messages")
    receive do
      msg -> IO.inspect(msg)
    end
  end
end

Monitor1.run()

defmodule Monitor2 do
  def sleeping_function(parent) do
    IO.inspect("[CHILD] Sending message")
    send(parent, {:ok, "wtf"})
    IO.inspect("[CHILD] Sleeping")
    :timer.sleep(500)
    IO.inspect("[CHILD] Receiving messages")

    receive do
      msg -> IO.inspect(msg)
    end
  end

  def sad_run() do
    IO.inspect("[PARENT] Spawning link")
    spawn_monitor(__MODULE__, :sleeping_function, [self])
    IO.inspect("[PARENT] Exiting")
    exit(:parent_boom)
  end
end

Monitor2.sad_run()
