library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

-- gpr file (general purpose register file) 
-- predstavlja registarski fajl sa 32 registra opste namene
-- deklaracije tipova su date u vlsi_pkg
-- gpr_file podrzava vise citanja u isto vreme i dobijanje vrednosti u istom taktu.
-- gpr_file podrzava vise upisa u isto vreme
-- VAZNO: gpr_file ne sadrzi nikakvu sinhronizaciju upisa. To se mora raditi eksteksno. 
entity gpr_file is
	port (
		clk : in std_logic;
		rst : in std_logic;
		in_data: in gpr_in_data_t;
		out_data : out gpr_out_data_t
	);
end entity gpr_file;

-- mislim da ovo nije potrebno komentarisati, kod je poprilicno self-descriptive
architecture RTL of gpr_file is
	signal gpr_reg, gpr_next : registers;

	function reset_gpr return registers is
		variable to_ret : registers;
	begin
		for i in registers'range loop
			to_ret(i) := (others => '0');
		end loop;
		return to_ret;
	end function reset_gpr;
	
begin
	process (clk, rst) is
	begin
		if rst = '1' then
			gpr_reg <= reset_gpr;
		elsif rising_edge(clk) then
			gpr_reg <= gpr_next;
		end if;
	end process;
	
	read_process : process(in_data.read_address, gpr_reg) is
	begin
		for i in in_data.read_address'range loop
			out_data.value(i) <= gpr_reg(to_integer(unsigned(in_data.read_address(i))));
		end loop;
	end process read_process;
	
	write_process : process (in_data.write_data_arr, gpr_reg) is
	begin
		gpr_next <= gpr_reg;
		for i in in_data.write_data_arr'range loop
			if in_data.write_data_arr(i).write = '1' then
				gpr_next(to_integer(unsigned(in_data.write_data_arr(i).address))) 
					<= in_data.write_data_arr(i).value;
			end if;
		end loop;
	end process write_process;

end architecture RTL;
