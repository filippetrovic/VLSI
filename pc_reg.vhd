library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity pc_reg is
	port(
		clk : in  std_logic;
		inc : in  std_logic;
		ld  : in  std_logic;
		d   : in  address_t;
		q   : out address_array_t;
		p   : out address_array_t
	);
end entity pc_reg;

architecture behav of pc_reg is
	signal reg_next : address_array_t;
	signal reg_prev : address_array_t;
begin
	
	q <= reg_next;
	p <= reg_prev;
	
	process(clk) is
	begin
		if rising_edge(clk) then
			if ld = '1' then
				reg_next(0) <= std_logic_vector(unsigned(d));
				reg_next(1) <= std_logic_vector(unsigned(d) + 1);
				reg_prev(0) <= std_logic_vector(unsigned(d) - 2);
				reg_prev(1) <= std_logic_vector(unsigned(d) - 1);
			elsif inc = '1' then
				reg_prev <= reg_next;
				for i in reg_next'range loop
					reg_next(i) <= std_logic_vector(unsigned(reg_next(i)) + 2);
				end loop;
			end if;
		end if;
	end process;

end architecture behav;

