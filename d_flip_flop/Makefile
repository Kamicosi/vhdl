SIM = ghdl
TOPLEVEL_LANG = vhdl
VHDL_SOURCES = $(shell pwd)/dff.vhdl
TOPLEVEL = dff
MODULE = dff_tb
SIM_ARGS = --wave=dff.ghw

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	rm -rf *.ghw *.xml __pycache__