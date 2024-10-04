library ieee;
use ieee.std_logic_1164.all;
--------------------------------------------------------------------------------
--                                                                             -
-- Simple module to test cocotb out with                                       -
--                                                                             -
--------------------------------------------------------------------------------
entity dff is
    port (
        clk     : in std_logic;
        reset   : in std_logic;
        d       : in std_logic;
        q       : out std_logic
    );
end entity;

architecture rtl of dff is
begin
    process (clk, reset)
    begin
        if reset = '1' then
            q <= '0';
        elsif rising_edge(clk) then
            q <= d;
        end if;
    end process;
end architecture;