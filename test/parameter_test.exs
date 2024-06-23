defmodule IntcodeComputer.ParameterTest do
  use ExUnit.Case, async: true
  alias IntcodeComputer.Parameter
  doctest IntcodeComputer.Parameter

  describe "new/2" do
    test "creates a position parameter" do
      assert Parameter.new(0, 42) == {:position, 42}
    end

    test "creates an immediate parameter" do
      assert Parameter.new(1, 42) == {:immediate, 42}
    end

    test "creates a relative parameter" do
      assert Parameter.new(2, 42) == {:relative, 42}
    end

    test "raises an error for invalid mode" do
      assert_raise FunctionClauseError, fn ->
        Parameter.new(3, 42)
      end
    end
  end
end
