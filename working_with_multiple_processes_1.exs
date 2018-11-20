defmodule Person do
  def loop do
    receive do
      {sender, {:token, token}} ->
        send(sender, {:ok, token})
        loop()
    end
  end

  def generate_token do
    4_294_967_296 |> :rand.uniform() |> Integer.to_string() |> String.pad_trailing(10, "0")
  end
end

defmodule Runner do
  def listen() do
    receive do
      {:ok, token} ->
        IO.puts(token)
        listen()
    end
  end
end

fred_token = "Fred"
fred = spawn(Person, :loop, [])
betty_token = "Betty"
betty = spawn(Person, :loop, [])

for i <- 1..100 do
  send(fred, {self(), {:token, fred_token}})
  receive do
    {:ok, token} ->
      IO.puts(token)
  end
end

for i <- 1..100 do
  send(betty, {self(), {:token, betty_token}})
  receive do
    {:ok, token} ->
      IO.puts(token)
  end
end
