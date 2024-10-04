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
    type fsm_state is (IDLE, RECEIVE, STOP);
    -- Signals
    signal current_state    : fsm_state;
    signal next_state       : fsm_state;
    signal bit_num          : integer;
    signal data             : std_logic_vector(7 downto 0);
begin
    -- Sequential logic
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            current_state <= IDLE;
            o_data <= (others => '0');
            o_data_valid <= '0';
        elsif rising_edge(i_clk) and i_rx_en = '1' then
            case current_state is
                when IDLE =>
                    bit_num <= 0;
                    if i_rx = '0' then 
                        o_data_valid <= '0'; 
                    end if;
                when RECEIVE =>
                    data(bit_num) <= i_rx;
                    bit_num <= bit_num + 1;
                when STOP =>
                    if i_rx = '1' then
                        o_data <= data;
                        o_data_valid <= '1';
                    end if;
                when others =>
                    null;
            end case;
            current_state <= next_state;
        end if;
    end process;

    -- Combinational logic
    process(current_state, bit_num, i_rx)
    begin
        case current_state is
            when IDLE =>
                if i_rx = '0' then
                    next_state <= RECEIVE;
                else
                    next_state <= IDLE;
                end if;
            when RECEIVE =>
                if bit_num = 7 then
                    next_state <= STOP;
                else
                    next_state <= RECEIVE;
                end if;
            when STOP =>
                next_state <= IDLE;
            when others =>
                next_state <= IDLE;
        end case;
    end process;

end architecture;

