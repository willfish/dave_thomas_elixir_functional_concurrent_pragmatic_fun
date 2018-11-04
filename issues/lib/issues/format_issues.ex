defmodule Issues.FormatIssues do
  @headers ~w[# created_at title]
  @default_accumulator %{
    id: 1,
    created_at: 1,
    title: 1,
    rows: []
  }

  @doc """
  Format issues as a table:
   #  | created_at           | title
  ----+----------------------+-----------------------------------------
  889 | 2013-03-16T22:03:13Z | MIX_PATH environment variable (of sorts)
  892 | 2013-03-20T19:22:07Z | Enhanced mix test --cover
  893 | 2013-03-21T06:23:00Z | mix test time reports
  898 | 2013-03-23T19:19:08Z | Add mix compile --warnings-as-errors

  Everything needs padding dynamically according to the maximum length
  of the value in the column
  """
  def format(issues) do
    issues
    |> extract_issues()
    |> tabularize()
  end

  def extract_issues(issues) do
    Enum.reduce(issues, @default_accumulator, &extract_issue/2)
  end

  def tabularize(issues_with_metadata) do
    tabularize_row = fn [id, created_at, title] ->
      [
        String.pad_trailing(id, issues_with_metadata.id),
        String.pad_trailing(created_at, issues_with_metadata.created_at),
        String.pad_trailing(title, issues_with_metadata.title)
      ]
      |> Enum.join(" | ")
    end

    padded_header = tabularize_row.(@headers)
    padded_middle = tabularize_row.(["", "", ""]) |> String.replace(" | ", "-+-") |> String.replace(" ", "-")

    padded_rows =
      issues_with_metadata.rows
      |> Enum.map(tabularize_row)

    [padded_header | [padded_middle | padded_rows]]
    |> Enum.join("\n")
  end

  def extract_issue(issue, acc) do
    id = issue |> Map.get("id") |> Integer.to_string()
    created_at = Map.get(issue, "created_at")
    title = Map.get(issue, "title")

    issue = [id, created_at, title]

    new_id_size = String.length(id)
    new_created_at_size = String.length(created_at)
    new_title_size = String.length(title)

    acc = update_size(:id, acc, acc.id, new_id_size)
    acc = update_size(:created_at, acc, acc.created_at, new_created_at_size)
    acc = update_size(:title, acc, acc.title, new_title_size)

    Map.put(acc, :rows, [issue | acc.rows])
  end

  def update_size(_, acc, prev_size, new_size) when prev_size >= new_size, do: acc

  def update_size(key, acc, _, new_size) do
    Map.put(acc, key, new_size)
  end
end
