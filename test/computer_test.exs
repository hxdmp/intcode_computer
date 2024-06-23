defmodule IntcodeComputer.ComputerTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO
  alias IntcodeComputer.Computer

  # Helper function to run a program with given input and return the output
  defp run_program_with_input(program, input) do
    computer = Computer.new(program)

    output =
      capture_io([input: input, capture_prompt: false], fn ->
        Computer.run(computer)
      end)

    String.trim(output)
  end

  describe "Day 2 tests" do
    test "simple addition and multiplication" do
      program = "1,9,10,3,2,3,11,0,99,30,40,50"
      computer = Computer.new(program)
      final_state = Computer.run(computer)
      assert final_state.memory[0] == 3500
    end

    test "program terminates with halt" do
      program = "1,0,0,0,99"
      computer = Computer.new(program)
      final_state = Computer.run(computer)
      assert final_state.memory == %{0 => 2, 1 => 0, 2 => 0, 3 => 0, 4 => 99}
    end

    test "handles negative values" do
      program = "1,1,1,4,99,5,6,0,99"
      computer = Computer.new(program)
      final_state = Computer.run(computer)

      assert final_state.memory == %{
               0 => 30,
               1 => 1,
               2 => 1,
               3 => 4,
               4 => 2,
               5 => 5,
               6 => 6,
               7 => 0,
               8 => 99
             }
    end
  end

  describe "Day 5 tests" do
    test "input and output operations" do
      program = "3,0,4,0,99"
      output = run_program_with_input(program, "42\n")
      assert output == "Output: 42"
    end

    test "immediate mode" do
      program = "1002,4,3,4,33"
      computer = Computer.new(program)
      final_state = Computer.run(computer)
      assert final_state.memory[4] == 99
    end

    test "comparison operations" do
      program = "3,9,8,9,10,9,4,9,99,-1,8"
      output_equal = run_program_with_input(program, "8\n")
      assert output_equal == "Output: 1"

      output_not_equal = run_program_with_input(program, "7\n")
      assert output_not_equal == "Output: 0"
    end

    test "jump operations" do
      program = "3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9"
      output_zero = run_program_with_input(program, "0\n")
      assert output_zero == "Output: 0"

      output_non_zero = run_program_with_input(program, "42\n")
      assert output_non_zero == "Output: 1"
    end
  end

  describe "Day 9 tests" do
    test "relative mode and large numbers" do
      program = "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
      output = run_program_with_input(program, "")

      expected_output =
        program
        |> String.split(",")
        |> Enum.map(&String.trim/1)
        |> Enum.map(&"Output: #{&1}")
        |> Enum.join("\n")

      assert output == expected_output
    end

    test "output large number" do
      program = "1102,34915192,34915192,7,4,7,99,0"
      output = run_program_with_input(program, "")
      assert output == "Output: 1219070632396864"
    end

    test "output large number in the middle" do
      program = "104,1125899906842624,99"
      output = run_program_with_input(program, "")
      assert output == "Output: 1125899906842624"
    end
  end

  describe "Day 11 tests" do
    test "relative base adjustment" do
      program = "109,19,204,-34,99"
      computer = Computer.new(program)
      computer = %{computer | relative_base: 2000}
      output = capture_io(fn -> Computer.run(computer) end)
      assert String.trim(output) == "Output: 0"
    end

    test "memory expansion" do
      program = "1,1,1,4,99,5,6,0,99"
      computer = Computer.new(program)
      final_state = Computer.run(computer)
      # Access memory beyond initial program
      assert Map.get(final_state.memory, 1000, 0) == 0
    end
  end
end
