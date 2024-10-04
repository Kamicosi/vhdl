# A collection of projects for learning and mastering VHSIC Hardware Description Language, or VHDL.

## Goals
 - Learn the VHDL hardware description language
 - Experiment with different verification strategies
 - Gain experience working on larger, more complex designs

## Technology used
The VHDL simulator used is `ghdl`. Modules that output `ghw` files can have
their signals viewed with `gtkwave`. Testbenches are either written in VHDL or
in Python using `cocotb`.

## Setup
Install the VHDL simulator and waveform viewer:
```
sudo apt install ghdl gtkwave
```
### Python-based testbenches only
In the project root, create a python virtual environment:
```
python -m venv .venv
```
Activate the virtual environment:
```
source .venv/bin/activate
```
Install the required libraries:
```
pip install -r requirements.txt
```
You will have to re-activate the environment every time you start a new session.

## Usage
In each module:
 - `make` - Runs the tests
 - `make clean` - Clean the build files
