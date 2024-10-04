library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use std.env.finish;

-- Empty entity for testbench
entity uart_rx_tb is
end entity;

architecture tb of uart_rx_tb is
    ----------------------------------------------------------------------------
    -- Functions                                                               -
    ----------------------------------------------------------------------------
    function to_std_logic_vector(a : string) return std_logic_vector is
        variable ret    : std_logic_vector(a'length-1 downto 0);
    begin
        for i in 0 to a'length-1 loop
            case a(i+1) is
                when '0'    => ret(i) := '0';
                when '1'    => ret(i) := '1';
                when others => ret(i) := 'X';
            end case;
        end loop;
        return ret;
    end function to_std_logic_vector;
    ----------------------------------------------------------------------------
    -- Signals                                                                 -
    ----------------------------------------------------------------------------
    -- Constants
    constant TV_SIZE_IN             : integer := 3;
    constant TV_SIZE_OUT            : integer := 9;
    -- Clock
    signal i_clk                    : std_logic := '0';
    -- Test vector signals
    signal tv_signals_in            : std_logic_vector(TV_SIZE_IN-1 downto 0)
                                        := (others => '0');
    signal tv_signals_out           : std_logic_vector(TV_SIZE_OUT-1 downto 0);
    signal i_reset                  : std_logic;
    signal i_rx                     : std_logic;
    signal i_rx_en                  : std_logic;
    signal o_data                   : std_logic_vector(0 to 7);
    signal o_data_valid             : std_logic;
    -- signal o_data_expected          : std_logic_vector(7 downto 0);
    -- signal o_data_valid_expected    : std_logic;
begin
    -- Constant expressions
    i_reset                     <= tv_signals_in(0);
    i_rx                        <= tv_signals_in(1);
    i_rx_en                     <= tv_signals_in(2);
    tv_signals_out(8 downto 1)  <= o_data;
    tv_signals_out(0)           <= o_data_valid;

    ----------------------------------------------------------------------------
    -- Entities                                                                -
    ----------------------------------------------------------------------------
    DUT : entity work.uart_rx(rtl)
    port map(
        i_clk => i_clk,
        i_reset => i_reset,
        i_rx => i_rx,
        i_rx_en => i_rx_en,
        o_data => o_data,
        o_data_valid => o_data_valid
    );

    ----------------------------------------------------------------------------
    -- Processes                                                               -
    ----------------------------------------------------------------------------
    clock_generation: process
        constant C_CLK                  : time := 10 ns;
    begin
        -- Got from the internet, idk if this is what I want
        i_clk <= '0' after C_CLK, '1' after 2*C_CLK;
        wait for 2*C_CLK;
    end process;

    vector_sequencing: process
        file tv_file                    : text open read_mode is "uart_rx.tv";
        variable line_buffer            : line;
        variable line_number            : integer := 0;
        variable input_str              : string(1 to 3);
        variable expected_str           : string(1 to 10);
    begin
        while (not endfile(tv_file))
        loop
            -- Read vector
            readline(tv_file, line_buffer);     -- Read entire line
            line_number := line_number + 1;
            read(line_buffer, input_str);       -- Get the inputs
            if input_str(1) = '#' then          -- Ignore comments
                next;
            end if;
            read(line_buffer, expected_str);    -- Get expected outputs
            tv_signals_in <= to_std_logic_vector(input_str); -- Apply signals
            wait until i_clk = '1'; -- Clock in inputs
            wait until i_clk = '0'; -- Compare outputs on negative edge

            -- Check outputs
            -- Note: We do (2 to 10) because the space between the vectors is
            --  included for some reason
            if to_string(tv_signals_out) /= expected_str(2 to 10) then
                report integer'image(line_number) &
                    ": Input: " &
                    input_str &
                    " Expected: " &
                    expected_str(2 to 10) &
                    " Output:" &
                    to_string(tv_signals_out);
                file_close(tv_file);
                finish;
            end if;
        end loop;
        report "Tests passed!";
        file_close(tv_file);
        finish;
    end process;
end architecture;