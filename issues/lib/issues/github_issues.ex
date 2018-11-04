defmodule Issues.GithubIssues do
  @github_url Application.get_env(:issues, :github_url)
  @user_agent [{"User-agent", "Elixir william.michael.fish@gmail.com"}]

  def fetch(user, project) do
    user
    |> issues_url(project)
    |> get()
    |> handle_response()
  end

  defp issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def get(url), do: HTTPoison.get(url, @user_agent)

  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error(),
      body |> Poison.Parser.parse!(%{})
    }
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    {:error, body}
  end

  def check_for_error(200), do: :ok
  def check_for_error(_), do: :error
end
