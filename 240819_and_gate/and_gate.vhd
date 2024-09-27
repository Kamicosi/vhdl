library ieee;
use ieee.std_logic_1164.all;

entity and_gate is
port
(
	i_x: in std_logic;
	i_y: in std_logic;
	o_f: out std_logic
);
end;

architecture rtl of and_gate is
begin
	o_f <= i_x and i_y;
end rtl;
