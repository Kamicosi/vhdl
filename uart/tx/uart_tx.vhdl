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
        o_data_ready    : out std_logic;    -- comb
        -- Output to rx module
        o_tx            : out std_logic;    -- comb
        o_rx_en         : out std_logic     -- comb
    );
end entity;

architecture rtl of uart_tx is
    type fsm_state is (IDLE, START, TRANSMIT, STOP);
    signal current_state    : fsm_state;                    -- seq
    signal next_state       : fsm_state;                    -- comb
    signal r_data           : std_logic_vector(7 downto 0); -- seq
    signal bit_num          : integer;                      -- seq
begin
    -- Sequential logic
    process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            current_state <= IDLE;
        elsif rising_edge(i_clk) then
            case current_state is
                when IDLE =>
                    if i_data_valid = '1' then
                        r_data <= i_data;
                    end if;
                when START =>
                    bit_num <= 0;
                when TRANSMIT =>
                    bit_num <= bit_num + 1;
                when STOP =>
                    if i_data_valid = '1' then
                        r_data <= i_data;
                    end if;
            end case;
            current_state <= next_state;
        end if;
    end process;

    -- Combinational logic
    process(all)
    begin
        o_data_ready <= '0';
        o_tx <= '1';
        o_rx_en <= '0';
        next_state <= IDLE;
        if i_reset = '0' then
            case current_state is
                when IDLE =>
                    o_data_ready <= '1';
                    if i_data_valid = '1' then
                        next_state <= START;
                    end if;
                when START =>
                    o_tx <= '0';
                    o_rx_en <= '1';
                    next_state <= TRANSMIT;
                when TRANSMIT =>
                    o_tx <= r_data(bit_num);
                    o_rx_en <= '1';
                    if bit_num = 7 then
                        next_state <= STOP;
                    else
                        next_state <= TRANSMIT;
                    end if;
                when STOP =>
                    o_rx_en <= '1'; -- only difference from IDLE
                    o_data_ready <= '1';
                    if i_data_valid = '1' then
                        next_state <= START;
                    end if;
            end case;
        end if;
    end process;

end architecture;