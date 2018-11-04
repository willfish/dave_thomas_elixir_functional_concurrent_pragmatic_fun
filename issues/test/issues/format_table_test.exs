defmodule FormatTableTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Issues.FormatTable, as: TF

  @simple_test_data [
    %{"c1" => "r1 c1", "c2" => "r1 c2", "c3" => "r1 c3", "c4" => "r1+++c4"},
    %{"c1" => "r2 c1", "c2" => "r2 c2", "c3" => "r2 c3", "c4" => "r2 c4"},
    %{"c1" => "r3 c1", "c2" => "r3 c2", "c3" => "r3 c3", "c4" => "r3 c4"},
    %{"c1" => "r4 c1", "c2" => "r4++c2", "c3" => "r4 c3", "c4" => "r4 c4"}
  ]
  @headers ~w[c1 c2 c4]

  @expected """
  c1    | c2     | c4     
  ------+--------+--------
  r1 c1 | r1 c2  | r1+++c4
  r2 c1 | r2 c2  | r2 c4  
  r3 c1 | r3 c2  | r3 c4  
  r4 c1 | r4++c2 | r4 c4  
  """
  test "format/2 correctly prints the input data" do
    actual = TF.format(@simple_test_data, @headers)

    assert actual == @expected
  end
end
