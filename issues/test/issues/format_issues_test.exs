defmodule Issues.FormatIssuesTest do
  use ExUnit.Case

  import Issues.FormatIssues

  @fixtures [
    %{
      "id" => 12345,
      "created_at" => "2018-11-03T09:03:45Z",
      "title" => "Support subnormal floats in Float.ratio/1"
    },
    %{
      "id" => 145,
      "created_at" => "2018-11-03T09:03:45Z",
      "title" => "Foo"
    }
  ]
  test "format/1 formats correctly" do
    actual = format(@fixtures)

    expected = """
    #     | created_at           | title                                    
    ------+----------------------+------------------------------------------
    145   | 2018-11-03T09:03:45Z | Foo                                      
    12345 | 2018-11-03T09:03:45Z | Support subnormal floats in Float.ratio/1
    """

    assert actual == String.trim(expected)
  end
end
