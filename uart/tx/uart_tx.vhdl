library ieee;
use ieee.std_logic_1164.all;

entity uart_tx is
    port (
        -- Clock and reset
        i_clk           : in std_logic;
        i_reset         : in std_logic;
        -- Input data to transmit
        i_data          : in std_logic_vector(7 downto 0);
        i_data_valid    : in std_logic;
        -- Data is sent and module is ready for next data
        o_data_ready    : out std_logic;
        -- Output to rx module
        o_tx            : out std_logic;
        o_rx_en         : out std_logic;
    );

    architecture rtl of uart_tx is
        type fsm_state is (IDLE, START, TRANSMIT, STOP);
        signal current_state    : fsm_state;
        signal next_state       : fsm_state;
        signal r_data           : std_logic_vector(7 downto 0);
        signal bit_num          : integer;
    begin
        -- Sequential logic
        process(i_clk, i_reset)
        begin
        end

        -- Combinational logic
        process(all)
        begin
        end

    end architecture;
end entity;