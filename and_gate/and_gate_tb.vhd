entity and_gate_tb is
end and_gate_tb;

library ieee;
use ieee.std_logic_1164.all;

architecture test of and_gate_tb is
	signal and_in	: std_logic_vector(1 downto 0) := (others => '0');
	alias i_x is and_in(0);
	alias i_y is and_in(1);
	signal o_f		: std_logic;
begin
	DUT: entity work.and_gate(rtl)
	port map
	(
		i_x =>	i_x,
		i_y =>	i_y,
		o_f =>	o_f
	);

	stimulus: process
	begin
		and_in <= "00"; wait for 10 ns; assert o_f = '0' report "input 00 failed" severity failure;
		and_in <= "01"; wait for 10 ns; assert o_f = '0' report "input 01 failed" severity failure;
		and_in <= "10"; wait for 10 ns; assert o_f = '0' report "input 10 failed" severity failure;
		and_in <= "11"; wait for 10 ns; assert o_f = '1' report "input 11 failed" severity failure;
		report "Test passed!";
		wait;
	end process;
end test;

