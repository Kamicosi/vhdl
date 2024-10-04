import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer
from cocotb.types import LogicArray

# Most of this is based on the 'Usage' section of the cocotb README.md:
# https://github.com/cocotb/cocotb

@cocotb.test()
async def tx_simple(dut):
    """We can transmit a single byte"""
    # Reset everything
    dut.i_reset.value = 1
    await Timer(2, units="ns")
    assert dut.o_data_ready.value == 0
    assert dut.o_tx.value == 1
    assert dut.o_rx_en.value == 0

    # Deassert reset
    dut.i_reset.value = 0
    await Timer(2, units="ns")

    # Start clocking
    clock = Clock(dut.i_clk, 10, units="us")
    cocotb.start_soon(clock.start(start_high=False))

    # Send random number
    assert dut.o_data_ready == 1
    assert dut.o_tx == 1
    assert dut.o_rx_en == 0
    val = random.randint(0, 255)
    dut.i_data.value = val
    dut.i_data_valid.value = 1
    await RisingEdge(dut.i_clk)
    await FallingEdge(dut.i_clk)

    # Start bit
    assert dut.o_data_ready == 0
    assert dut.o_tx == 0
    assert dut.o_rx_en == 1
    await RisingEdge(dut.i_clk)
    await FallingEdge(dut.i_clk)

    # 8 data bits
    for i in range(8):
        assert dut.o_tx.value == (val >> i) & 1
        await RisingEdge(dut.i_clk)
        await FallingEdge(dut.i_clk)

    # Stop bit
    assert dut.o_data_ready == 0
    assert dut.o_tx == 1
    assert dut.o_rx_en == 1
    await RisingEdge(dut.i_clk)
    await FallingEdge(dut.i_clk)

    # Idle
    assert dut.o_data_ready == 1
    assert dut.o_tx == 1
    assert dut.o_rx_en == 0