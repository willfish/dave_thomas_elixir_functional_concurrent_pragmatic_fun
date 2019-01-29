defmodule Scheduler do
  def run(num_processes, module, func, to_calculate) do
    1..num_processes
    |> Enum.map(fn _ -> spawn(module, func, [self()]) end)
    |> schedule_processes(to_calculate, [])
  end

  defp schedule_processes(processes, queue, results) do
    receive do
      {:ready, pid} ->
        case queue do
          [] ->
            send(pid, {:shutdown})

            if length(processes) > 1 do
              processes
              |> List.delete(pid)
              |> schedule_processes(queue, results)
            else
              Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
            end

          [head | tail] ->
            send(pid, {:count_cats, head, self()})
            schedule_processes(processes, tail, results)
        end

      {:answer, file, cat_count, _pid} ->
        schedule_processes(processes, queue, [{file, cat_count} | results])
    end
  end
end

defmodule CatCounter do
  def loop(scheduler) do
    send(scheduler, {:ready, self()})

    receive do
      {:count_cats, file, client} ->
        count =
          file
          |> File.read!()
          |> :binary.matches("cat")
          |> length()

        send(client, {:answer, file, count, self()})
        loop(scheduler)

      {:shutdown} ->
        exit(:normal)
    end
  end
end
to_process = "/Users/william/Downloads/*pdf"
             |> Path.wildcard()
# to_process = ["cats/cat.log", "cats/frog.log"]
# num_processes = 1
# num_processes
# |> Scheduler.run(CatCounter, :loop, to_process)
# |> IO.inspect()
Enum.each(1..10, fn num_processes ->
  {time, result} =
    :timer.tc(Scheduler, :run, [num_processes, CatCounter, :loop, to_process])

  if num_processes == 1 do
    IO.inspect(result)
    IO.puts("\n # time (s)")
  end

  :io.format("~2B ~.2f~n", [num_processes, time / 1_000_000.0])
end)
