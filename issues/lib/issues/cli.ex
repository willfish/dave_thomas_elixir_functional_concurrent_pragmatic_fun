defmodule Issues.CLI do
  import Issues.TableFormatter, only: [print_table_for_columns: 2]

  @default_count 4
  @option_parser_index 1
  @moduledoc """
  Handle the command line parsing and the dispatch to the various functions that end up generating a table of the last _n_ issues in a github project
  """

  def run(argv) do
    argv
    |> parse_args()
    |> process()
    |> print_table_for_columns()
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.
  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    argv
    |> OptionParser.parse(switches: [help: :boolean], aliases: [h: :help])
    |> elem(@option_parser_index)
    |> args_to_internal_representation()
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_issues()
    |> last(5)
  end

  def process(_) do
    IO.puts("""
    usage: issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt(0)
  end

  def tabularize(issues) do
    Issues.FormatIssues.tabularize(issues)
  end

  defp args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  defp args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  defp args_to_internal_representation(_), do: :help

  defp decode_response({:ok, body}), do: body

  defp decode_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end

  def sort_issues(issues) do
    issues
    |> Enum.sort_by(fn issue -> Map.get(issue, "created_at") end, &>=/2)
  end

  def last(issues, count) do
    issues
    |> Enum.take(count)
    |> Enum.reverse()
  end
end
