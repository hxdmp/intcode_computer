defmodule IntcodeComputer do
  @moduledoc """
  Documentation for `IntcodeComputer`.
  """

  defdelegate new(program), to: IntcodeComputer.Computer
  defdelegate run(computer), to: IntcodeComputer.Computer
end
