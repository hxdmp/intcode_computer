defmodule IntcodeComputer.Parameter do
  @type t :: {:position, integer()} | {:immediate, integer()} | {:relative, integer()}

  @doc """
  Create a new parameter. This function raises an error if the mode is not 0, 1, or 2.

  ## Examples

  iex> Parameter.new(0, 42)
  {:position, 42}

  iex> Parameter.new(1, 42)
  {:immediate, 42}

  iex> Parameter.new(2, 42)
  {:relative, 42}

  iex> try do
  ...>   Parameter.new(100, 42)
  ...> rescue
  ...>   _ -> "oops"
  ...> end
  "oops"
  """
  @spec new(0 | 1 | 2, integer()) :: t()
  def new(mode, value) when mode in 0..2 do
    case mode do
      0 -> {:position, value}
      1 -> {:immediate, value}
      2 -> {:relative, value}
      _ -> raise("Invalid mode: #{mode}")
    end
  end
end
