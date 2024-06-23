defmodule IntcodeComputer.MultiDigitInput do
  @spec get_integer(String.t()) :: integer()
  def get_integer(prompt) do
    prompt
    |> IO.gets()
    |> String.trim()
    |> parse_integer()
  end

  @spec parse_integer(String.t()) :: integer()
  defp parse_integer(input) do
    case Integer.parse(input) do
      {number, ""} ->
        number

      _ ->
        IO.puts("Invalid input. Please enter a valid integer.")
        get_integer("Try again: ")
    end
  end
end
