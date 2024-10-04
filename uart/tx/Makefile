SIM = ghdl
TOPLEVEL_LANG = vhdl
VHDL_SOURCES = $(shell pwd)/uart_tx.vhdl
TOPLEVEL = uart_tx
MODULE = uart_tx_tb
SIM_ARGS = --wave=uart_tx.ghw

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	rm -rf *.ghw *.xml __pycache__