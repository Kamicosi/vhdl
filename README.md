 # A collection of projects for learning and mastering VHSIC Hardware Description Language, or VHDL.

## Goals
 - Learn the VHDL programming language
 - Experiment with different verification strategies
 - Gain experience working on larger, more complex designs

## Technology used
The VHDL simulator ussed is `ghdl`. Modules that output `ghw` files can have
their signals viewed with `gtkwave`. Testbenches are either written in VHDL or
in Python using `cocotb`.

## Setup
Install the VHDL simulator:
`sudo apt install ghdl`
(Optional) Install the waveform viewer:
`sudo apt install gtkwave`
You're now ready to run the VHDL-based testbenches.

In the project root, create a python virtual environment:
`python -m venv ./.venv`
Activate the virtual environment:
`source .venv/bin/activate`
Install the required libraries:
`pip install -r requirements.txt`
You're now ready to run the Python-based testbenches. You will have to
re-activate the environment every time you start a new session.

## Usage
In each module:
 - `make` - Runs the tests
 - `make clean` - Clean the build files
