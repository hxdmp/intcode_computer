defmodule IntcodeComputer.InstructionTest do
  use ExUnit.Case, async: true
  alias IntcodeComputer.Instruction

  describe "parse_with_modes/2" do
    test "parses add instruction" do
      assert Instruction.parse_with_modes(1, [1, 2, 3]) ==
               {:add, {:position, 1}, {:position, 2}, {:position, 3}}

      assert Instruction.parse_with_modes(1001, [1, 2, 3]) ==
               {:add, {:position, 1}, {:immediate, 2}, {:position, 3}}

      assert Instruction.parse_with_modes(11101, [1, 2, 3]) ==
               {:add, {:immediate, 1}, {:immediate, 2}, {:immediate, 3}}
    end

    test "parses multiply instruction" do
      assert Instruction.parse_with_modes(2, [4, 5, 6]) ==
               {:multiply, {:position, 4}, {:position, 5}, {:position, 6}}

      assert Instruction.parse_with_modes(1002, [4, 5, 6]) ==
               {:multiply, {:position, 4}, {:immediate, 5}, {:position, 6}}
    end

    test "parses input instruction" do
      assert Instruction.parse_with_modes(3, [7]) == {:input, {:position, 7}}
      assert Instruction.parse_with_modes(103, [7]) == {:input, {:immediate, 7}}
    end

    test "parses output instruction" do
      assert Instruction.parse_with_modes(4, [8]) == {:output, {:position, 8}}
      assert Instruction.parse_with_modes(104, [8]) == {:output, {:immediate, 8}}
    end

    test "parses jump_if_true instruction" do
      assert Instruction.parse_with_modes(5, [9, 10]) ==
               {:jump_if_true, {:position, 9}, {:position, 10}}

      assert Instruction.parse_with_modes(1105, [9, 10]) ==
               {:jump_if_true, {:immediate, 9}, {:immediate, 10}}
    end

    test "parses jump_if_false instruction" do
      assert Instruction.parse_with_modes(6, [11, 12]) ==
               {:jump_if_false, {:position, 11}, {:position, 12}}

      assert Instruction.parse_with_modes(1006, [11, 12]) ==
               {:jump_if_false, {:position, 11}, {:immediate, 12}}
    end

    test "parses less_than instruction" do
      assert Instruction.parse_with_modes(7, [13, 14, 15]) ==
               {:less_than, {:position, 13}, {:position, 14}, {:position, 15}}

      assert Instruction.parse_with_modes(2107, [13, 14, 15]) ==
               {:less_than, {:immediate, 13}, {:relative, 14}, {:position, 15}}
    end

    test "parses equals instruction" do
      assert Instruction.parse_with_modes(8, [16, 17, 18]) ==
               {:equals, {:position, 16}, {:position, 17}, {:position, 18}}

      assert Instruction.parse_with_modes(20108, [16, 17, 18]) ==
               {:equals, {:immediate, 16}, {:position, 17}, {:relative, 18}}
    end

    test "parses adjust_relative_base instruction" do
      assert Instruction.parse_with_modes(9, [19]) ==
               {:adjust_relative_base, {:position, 19}}

      assert Instruction.parse_with_modes(209, [19]) ==
               {:adjust_relative_base, {:relative, 19}}
    end

    test "parses halt instruction" do
      assert Instruction.parse_with_modes(99, []) == :halt
    end

    test "handles leading zeros in opcode" do
      assert Instruction.parse_with_modes(0001, [1, 2, 3]) ==
               {:add, {:position, 1}, {:position, 2}, {:position, 3}}
    end

    test "handles missing parameter modes" do
      assert Instruction.parse_with_modes(1, [1, 2, 3]) ==
               {:add, {:position, 1}, {:position, 2}, {:position, 3}}
    end
  end
end
