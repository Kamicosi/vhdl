import random

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer

@cocotb.test()
async def tx_simple(dut):
    """Transmit a single byte"""
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

    # Give it a random number
    assert dut.o_data_ready == 1
    assert dut.o_tx == 1
    assert dut.o_rx_en == 0
    val = random.randint(0, 255)
    dut.i_data.value = val
    dut.i_data_valid.value = 1
    await RisingEdge(dut.i_clk)
    await FallingEdge(dut.i_clk)
    dut.i_data_valid.value = 0

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

    # Stop bit (ready for next byte)
    assert dut.o_data_ready == 1
    assert dut.o_tx == 1
    assert dut.o_rx_en == 1
    await RisingEdge(dut.i_clk)
    await FallingEdge(dut.i_clk)

    # Idle
    assert dut.o_data_ready == 1
    assert dut.o_tx == 1
    assert dut.o_rx_en == 0

@cocotb.test()
async def tx_multiple_bytes(dut):
    """Send multiple bytes back-to-back with no gap in-between"""