# IntcodeComputer

An Elixir implementation of the Intcode Computer from Advent of Code 2019.

## Description

IntcodeComputer is an Elixir library that simulates the Intcode Computer, a virtual machine introduced in the Advent of Code 2019 programming puzzles. This implementation supports all operations from Days 2, 5, 9, and 11, including:

- Basic arithmetic (addition, multiplication)
- Input/Output operations
- Conditional jumps
- Comparisons
- Relative mode addressing
- Dynamic memory expansion

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `intcode_computer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:intcode_computer, "~> 0.1.0"}
  ]
end
```

## Usage

### CLI

This package comes with a custom mix task to run the computer with a given program:

```bash
mix intcode.run "3,0,4,0,99"
```

### Lib

Here's a basic example of how to use the IntcodeComputer:

```elixir
alias IntcodeComputer.Computer

Computer.new("3,0,4,0,99")
  |> Computer.run()

```

This will create a new Intcode Computer, load the program, and run it. Input and output are provided via stdin/stdout.

## Features

- Supports all Intcode operations from Advent of Code 2019 (Days 2, 5, 9, and 11)
- Customizable input and output handling via callback functions
- Expandable memory
- Relative mode addressing

## Testing

To run the tests:

```
mix test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
