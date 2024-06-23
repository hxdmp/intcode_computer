defmodule IntcodeComputer.Instruction do
  alias IntcodeComputer.Parameter

  @type t ::
          {:add, Parameter.t(), Parameter.t(), Parameter.t()}
          | {:multiply, Parameter.t(), Parameter.t(), Parameter.t()}
          | {:input, Parameter.t()}
          | {:output, Parameter.t()}
          | {:jump_if_true, Parameter.t(), Parameter.t()}
          | {:jump_if_false, Parameter.t(), Parameter.t()}
          | {:less_than, Parameter.t(), Parameter.t(), Parameter.t()}
          | {:equals, Parameter.t(), Parameter.t(), Parameter.t()}
          | {:adjust_relative_base, Parameter.t()}
          | :halt

  @opcodes %{
    1 => :add,
    2 => :multiply,
    3 => :input,
    4 => :output,
    5 => :jump_if_true,
    6 => :jump_if_false,
    7 => :less_than,
    8 => :equals,
    9 => :adjust_relative_base,
    99 => :halt
  }

  @spec parse_with_modes(integer(), [integer()]) :: t()
  def parse_with_modes(opcode, params) do
    [p3_mode, p2_mode, p1_mode | _] =
      opcode
      |> Integer.to_string()
      |> String.pad_leading(5, "0")
      |> String.to_charlist()
      # subtract the value of the char '0' to get the integer value (that was AI, I'm not that smart)
      |> Enum.map(&(&1 - ?0))

    case @opcodes[opcode_without_modes(opcode)] do
      :add ->
        [p1, p2, p3 | _] = params
        {:add, Parameter.new(p1_mode, p1), Parameter.new(p2_mode, p2), Parameter.new(p3_mode, p3)}

      :multiply ->
        [p1, p2, p3 | _] = params

        {:multiply, Parameter.new(p1_mode, p1), Parameter.new(p2_mode, p2),
         Parameter.new(p3_mode, p3)}

      :input ->
        {:input, Parameter.new(p1_mode, Enum.at(params, 0))}

      :output ->
        {:output, Parameter.new(p1_mode, Enum.at(params, 0))}

      :jump_if_true ->
        [p1, p2 | _] = params
        {:jump_if_true, Parameter.new(p1_mode, p1), Parameter.new(p2_mode, p2)}

      :jump_if_false ->
        [p1, p2 | _] = params
        {:jump_if_false, Parameter.new(p1_mode, p1), Parameter.new(p2_mode, p2)}

      :less_than ->
        [p1, p2, p3 | _] = params

        {:less_than, Parameter.new(p1_mode, p1), Parameter.new(p2_mode, p2),
         Parameter.new(p3_mode, p3)}

      :equals ->
        [p1, p2, p3 | _] = params

        {:equals, Parameter.new(p1_mode, p1), Parameter.new(p2_mode, p2),
         Parameter.new(p3_mode, p3)}

      :adjust_relative_base ->
        [p1 | _] = params
        {:adjust_relative_base, Parameter.new(p1_mode, p1)}

      :halt ->
        :halt
    end
  end

  # This operation effectively "cuts off" any parameter mode information and gives us just the last two digits, which
  # represent the actual opcode. (Thanks Claude :>)
  defp opcode_without_modes(opcode), do: rem(opcode, 100)
end
