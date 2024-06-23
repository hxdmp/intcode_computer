defmodule IntcodeComputer.Computer do
  @moduledoc """
  This module implements an Intcode computer, as described in the Advent of Code 2019.
  """
  alias IntcodeComputer.Instruction
  alias IntcodeComputer.Parameter

  @type t :: %{
          ip: non_neg_integer(),
          relative_base: non_neg_integer(),
          memory: %{non_neg_integer() => integer()},
          input_callback: (-> integer()),
          output_callback: (integer() -> nil)
        }

  @doc """
  Create a new Intcode computer from the given program.
  """
  @spec new(String.t()) :: t()
  def new(program) do
    memory =
      program
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.into(%{}, fn {v, k} -> {k, v} end)

    %{
      ip: 0,
      relative_base: 0,
      memory: memory,
      input_callback: fn ->
        IntcodeComputer.MultiDigitInput.get_integer("Input: ")
      end,
      output_callback: fn value -> IO.puts("Output: #{value}") end
    }
  end

  def set_input_callback(computer, callback) do
    %{computer | input_callback: callback}
  end

  def set_output_callback(computer, callback) do
    %{computer | output_callback: callback}
  end

  @spec get(t(), non_neg_integer()) :: integer() | nil
  def get(%{memory: memory}, address), do: Map.get(memory, address, 0)

  @spec set(t(), non_neg_integer(), integer()) :: t()
  def set(%{memory: memory} = computer, address, value) do
    %{computer | memory: Map.put(memory, address, value)}
  end

  @spec fetch_instruction(t()) :: Instruction.t()
  def fetch_instruction(%{ip: ip, memory: memory}) do
    opcode = Map.get(memory, ip)
    params = Enum.map(1..3, &Map.get(memory, ip + &1))
    Instruction.parse_with_modes(opcode, params)
  end

  @spec run(t()) :: t()
  def run(computer), do: execute(computer, fetch_instruction(computer))

  @doc """
  Fetch the value of a parameter based on its mode.

  ## Examples

  iex> fetch_parameter(%{memory: %{0 => 42}}, {:immediate, 0})
  0

  iex> fetch_parameter(%{memory: %{0 => 42}}, {:position, 0})
  42
  """
  @spec fetch_parameter(t(), Parameter.t()) :: integer()
  def fetch_parameter(_, {:immediate, value}), do: value
  def fetch_parameter(computer, {:position, address}), do: get(computer, address)

  def fetch_parameter(computer, {:relative, offset}),
    do: get(computer, computer.relative_base + offset)

  @spec get_output_address(t(), Parameter.t()) :: integer()
  defp get_output_address(_, {:position, address}), do: address
  defp get_output_address(computer, {:relative, offset}), do: computer.relative_base + offset

  defp execute(computer, :halt), do: computer

  defp execute(computer, {:input, address}) do
    output_address = get_output_address(computer, address)

    data = computer.input_callback.()

    computer
    |> set(output_address, data)
    |> Map.update!(:ip, &(&1 + 2))
    |> run()
  end

  defp execute(computer, {:output, address}) do
    output = fetch_parameter(computer, address)
    computer.output_callback.(output)

    %{computer | ip: computer.ip + 2}
    |> run()
  end

  defp execute(computer, {:jump_if_true, p1, p2}) do
    p1 = fetch_parameter(computer, p1)
    p2 = fetch_parameter(computer, p2)

    next_ip = if p1 != 0, do: p2, else: computer.ip + 3

    if next_ip < 0, do: throw("user tried to set IP to a negative value, can't do that!")

    %{computer | ip: next_ip}
    |> run()
  end

  defp execute(computer, {:jump_if_false, p1, p2}) do
    p1 = fetch_parameter(computer, p1)
    p2 = fetch_parameter(computer, p2)

    next_ip = if p1 == 0, do: p2, else: computer.ip + 3

    if next_ip < 0, do: throw("user tried to set IP to a negative value, can't do that!")

    computer
    |> Map.update!(:ip, fn _ -> next_ip end)
    |> run()
  end

  defp execute(computer, {:less_than, p1, p2, p3}) do
    p1 = fetch_parameter(computer, p1)
    p2 = fetch_parameter(computer, p2)
    output_address = get_output_address(computer, p3)

    result = if p1 < p2, do: 1, else: 0

    computer
    |> set(output_address, result)
    |> Map.update!(:ip, &(&1 + 4))
    |> run()
  end

  defp execute(computer, {:equals, p1, p2, p3}) do
    p1 = fetch_parameter(computer, p1)
    p2 = fetch_parameter(computer, p2)
    output_address = get_output_address(computer, p3)

    result = if p1 == p2, do: 1, else: 0

    computer
    |> set(output_address, result)
    |> Map.update!(:ip, &(&1 + 4))
    |> run()
  end

  defp execute(computer, {:adjust_relative_base, p1}) do
    p1 = fetch_parameter(computer, p1)

    %{computer | relative_base: computer.relative_base + p1, ip: computer.ip + 2}
    |> run()
  end

  defp execute(computer, {operation, p1, p2, p3}) do
    a = fetch_parameter(computer, p1)
    b = fetch_parameter(computer, p2)
    output_address = get_output_address(computer, p3)

    result =
      case operation do
        :add -> a + b
        :multiply -> a * b
      end

    computer
    |> set(output_address, result)
    |> Map.update!(:ip, &(&1 + 4))
    |> run()
  end
end
