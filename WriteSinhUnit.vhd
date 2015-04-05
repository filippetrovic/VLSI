library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity writeSinhUnit is
	port (
		out_data: out write_data_array_t;
		in_data: in wsh_in_data_array_t
	);
end entity writeSinhUnit;

architecture RTL of writeSinhUnit is
	
begin
	transfer : process (in_data) is
	begin
		for i in out_data'range loop
			out_data(i).address <= in_data(i).address;
			out_data(i).value <= in_data(i).value;
		end loop;
	end process transfer;
	
	writeGen : process (in_data) is	
	begin
		for i in out_data'range loop
			out_data(i).write <= in_data(i).valid;
			for j in in_data'range loop
				
--				poredi se svako sa svakim.
--				ako je i != j, pokazuju na isti registar, ulaz j je validan, i.pc je manji od j.pc
--				onda ulaz i nije validan.
				if i /= j AND 
					in_data(i).address = in_data(j).address AND
					in_data(j).valid = '1' AND
					unsigned(in_data(i).pc) < unsigned(in_data(j).pc)
					then
					
					out_data(i).write <= '0'; 
					
				end if;
				
			end loop;

		end loop;
		
	end process writeGen;
	
	
end architecture RTL;
