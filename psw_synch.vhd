library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

--	Jedinica za sinhronizaciju PSW registra.
--	Resava problem istovremenog upisa u psw iz dve ALU jedinica.
--	Cista kompbinaciona mreza.
--	Opisana je u readme (odogovr na pitanje sta sa PSW i u delu Backend kod opisa PSW)
entity psw_synch is
	port (
		in_data: in psw_synch_in_data_array_t;
		out_data: out psw_register_t;
		write: out std_logic
	);
end entity psw_synch;


architecture RTL of psw_synch is
	
begin
	synch : process (in_data) is
	begin
--		inicijalno nije bitna izlazna vrednost.
		out_data <= (others => '-');
		
--		pravilo je da u prvu ALU jedinicu ide Fica (inst sa manjim pc),
--		a u drugu ide Fedja (inst sa vecim pc). Zbog ovoga se pravilo za prosledjivanje
--		moze uprostiti da se uvek propusta Fedja ako je generisao psw, 
--		inace se propusta Fica ako je generisao psw. 
--		Zbog prve naredbe u procesu se generise samo jedan multiplekser za ovaj if blok.
		if in_data(1).update_psw = '1' then
			out_data <= in_data(1).psw_value;
		elsif in_data(0).update_psw = '1' then
			out_data <= in_data(0).psw_value;
		end if;
		
--		write je aktivno ako bilo koja ALU generise psw.
		write <= in_data(0).update_psw OR in_data(1).update_psw;
		
	end process synch;
	
end architecture RTL;
