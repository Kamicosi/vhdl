test:
	ghdl -c --std=08 uart_rx_tb.vhdl uart_rx.vhdl && ghdl -r --std=08 uart_rx_tb --vcd=run1.vcd

clean:
	ghdl --clean && rm -f work*.cf *.vcd

.PHONY: test clean