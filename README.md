 # A collection of projects for learning and mastering VHSIC Hardware Description Language, or VHDL.

## Goals
 - Learn the VHDL programming language
 - Experiment with different verification strategies
 - Gain experience working on larger, more complex designs

## Technology used
The VHDL simulator ussed is `ghdl`. Modules that output `ghw` files can have
their signals viewed with `gtkwave`. Testbenches are either written in VHDL or
in Python using `cocotb`.

## Usage
In each module:
 - `make` - Runs the tests
 - `make clean` - Clean the build files
