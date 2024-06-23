defmodule Mix.Tasks.Intcode.Run do
  use Mix.Task

  def run([program]) do
    IntcodeComputer.new(program)
    |> IntcodeComputer.run()
  end
end
