defmodule SpawnBasic do
  def greet do
    IO.puts("hello, world")
  end
end

defmodule Spawn1 do
  def greet do
    receive do
      {sender, message} ->
        send(sender, {:ok, "Hello, #{message}"})
        greet()
    end
  end
end

pid = spawn(Spawn1, :greet, [])
send(pid, {self(), "World!"})

receive do
  {:ok, message} -> IO.puts(message)
end

send(pid, {self(), "Twat"})

receive do
  {:ok, message} -> IO.puts(message)
end
