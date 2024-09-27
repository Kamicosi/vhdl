library ieee;
use ieee.std_logic_1164.all;

entity uart_rx is
    port (
        -- Control lines
        i_clk           : in std_logic;     -- FPGA clock
        i_reset         : in std_logic;     -- FPGA reset

        -- UART lines
        i_rx            : in std_logic;     -- UART RX line
        i_rx_en         : in std_logic;     -- UART enable

        -- Ouputs
        o_data          : out std_logic_vector(7 downto 0); -- Output UART data
                                                            -- after a full
                                                            -- recieve
        o_data_valid    : out std_logic     -- Output data is valid
    );


end entity;

architecture rtl of uart_rx is
    -- Types
    type fsm_state is (IDLE, START, RECEIVE, STOP);
    -- Signals
    signal current_state    : fsm_state;
    signal next_state       : fsm_state;
begin

    -- Handle transitioning to the next state
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            current_state <= IDLE;
        elsif rising_edge(i_clk) then
            current_state <= next_state;
        end if;
    end process;

end architecture;

