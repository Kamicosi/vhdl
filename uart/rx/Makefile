test:
	ghdl -c --std=08 uart_rx_tb.vhdl uart_rx.vhdl
	ghdl -r --std=08 uart_rx_tb --wave=uart_rx.ghw

clean:
	ghdl --clean
	rm -f work*.cf *.vcd *.ghw

.PHONY: test clean