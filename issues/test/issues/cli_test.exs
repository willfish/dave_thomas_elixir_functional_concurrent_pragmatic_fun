defmodule Issues.CLITest do
  use ExUnit.Case

  import Issues.CLI

  test ":help is returned when -h is given" do
    assert parse_args(["-h", "foo"]) == :help
  end

  test ":help is returned when --help is given" do
    assert parse_args(["--help", "foo"]) == :help
  end

  test "three values returned if three args given" do
    actual = parse_args(["foo", "bar", "2"])
    expected = {"foo", "bar", 2}

    assert actual == expected
  end

  test "three values returned if two args given" do
    actual = parse_args(["foo", "bar"])
    expected = {"foo", "bar", 4}

    assert actual == expected
  end

  test "sort_issues/1 sorts in descending order" do
    fixture = created_at_fixture(["c", "a", "b"])
    issues = sort_issues(fixture)
    assert issues == [
      %{"created_at" => "c"},
      %{"created_at" => "b"},
      %{"created_at" => "a"}
    ]
  end

  def created_at_fixture(list) do
    for value <- list, do: %{"created_at" => value}
  end
end
