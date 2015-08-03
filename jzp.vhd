library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity jzp is
	port (
		in_data: in jzp_in_data_t;
		out_data: out jzp_out_data_t
	);
end entity jzp;

architecture RTL of jzp is
	
begin
	
	comp : process (in_data) is
	begin
--		inicijalno se pretpostavlja da nema prosledjivanja.
		out_data.out_value <= in_data.from_gpr;
		
--		proverava se da li ima prosledjivanja:
--		za svaki izlaz iz WSU se proveri da li je validan (write == 1) AND 
--		da li su adrese registara iste.
--		WSU garantuje da ne moze da se dogodi da na svojim izlazim
--		ima dve vrednosti koje su validne i imaju istu adresu. 
		for i in in_data.from_wsu'range loop
			
			if 	in_data.from_wsu(i).write = '1' AND
				in_data.from_wsu(i).address = in_data.address
			then
				out_data.out_value <= in_data.from_wsu(i).value;
			end if;
			
		end loop;
		
	end process comp;
	
	
end architecture RTL;
