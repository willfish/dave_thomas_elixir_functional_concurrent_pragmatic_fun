defmodule Link2 do
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
    spawn_link(Child, :sleeping_function, [self])
    IO.inspect("[PARENT] Exiting")
    exit(:parent_boom)
  end
end

Link2.sad_run()
