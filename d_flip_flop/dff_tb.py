import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer
from cocotb.types import LogicArray

# Most of this is based on the 'Usage' section of the cocotb README.md:
# https://github.com/cocotb/cocotb

@cocotb.test()
async def simple(dut):
    """Test that d propagates to q"""
    # Initial output is unknown
    assert LogicArray(dut.q.value) == LogicArray("X")

    # 10us clock
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start(start_high=False))

    # Assign random inputs
    for i in range(10):
        val = random.randint(0, 1)
        dut.d.value = val
        await RisingEdge(dut.clk)
        await FallingEdge(dut.clk)
        assert dut.q.value == val, f"output q was incorrect on the {i}th cycle"

@cocotb.test()
async def reset(dut):
    """Test the reset input"""
    # Reset flip-flop with no clock
    dut.reset.value = 1
    await Timer(2, units="ns")
    assert dut.q.value == 0

    # Clock in value while reset is high
    dut.d.value = 1
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start(start_high=False))
    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)
    assert dut.q.value == 0

    # Clock in value while reset is low
    dut.reset.value = 0
    await RisingEdge(dut.clk)
    await FallingEdge(dut.clk)
    assert dut.q.value == 1

    # Reset asynchronously
    dut.reset.value = 1
    await Timer(2, units="ns")
    assert dut.q.value == 0