library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

--	Stopko je SM koji generise izlazni stop signal.
--	Logika je sledeca: Ako je Fica STOP_M (ili ERROR_M) onda se prelazi u stanje STOP.
--	U STOP stanju se razmatra generisanje stop signala, i to tako sto se negira mem_busy.
--	U slucaju da je Fedja STOP_M onda se mora Fica izvrsiti (ako je npr BR ili Store).
--	OVo se postize dodavanjem jednog stanja izmedju WORK i STOP, koje se zove CHECK, 
--	koje u stvari unosi kasnjenje od jednog takta izmedju WORK i STOP, taman dovoljno da se BR izvrsi, 
--	ili MEM zapocne. Ukoliko BR skoci Fedja vise nije validan i vraca se u stanje WORK, 
--	inace se ide u STOP stanje i zaustavlja se procesor.	
entity stopko_unit is
	port (
		clk : in std_logic;
		rst : in std_logic;
		in_data : in stopko_in_data_t;
		in_control : in stopko_in_control_t;
		out_control : out stopko_out_control_t
	);
end entity stopko_unit;

architecture RTL of stopko_unit is
	
--	stanja state masine;
--	work je inicijalno stanje, tj. procesor radi.
--	check je stanje u kome se ostaje jedan takt i vrsi se provera da li treba zaustaviti cpu
--	stop je stanje u kome se zna da je doslo do zaustavljanja procesora, i generise se stop signal
	type state is (WORK_STATE, CHECK_STATE, STOP_STATE);
	
--	tretnutno i sledece stanje.
	signal PS, NS : state;
	
begin

	sync : process (clk, rst) is
	begin
		if rst = '1' then
			PS <= WORK_STATE;	
		elsif rising_edge(clk) then
			PS <= NS;
		end if;
	end process sync;
	
	comb : process (PS, in_data, in_control) is
	begin
		out_control.stall <= '0';
		out_control.stop  <= '0';
		
		case PS is 
			when WORK_STATE =>
				if in_data.instructions(0).valid = '1' and 
					(in_data.instructions(0).op = STOP_M or in_data.instructions(0).op = ERROR_M)
				then
					
					NS <= STOP_STATE;
					out_control.stall <= '1';
				
				elsif in_data.instructions(1).valid = '1' and
					(in_data.instructions(1).op = STOP_M or in_data.instructions(1).op = ERROR_M)
				then
				
					NS <= CHECK_STATE;
					out_control.stall <= '1';
				
				else
					
					NS <= WORK_STATE;
					out_control.stall <= '0';
					
				end if;
			when CHECK_STATE =>
				if in_data.instructions(1).valid = '1' then
					
					NS <= STOP_STATE;
					out_control.stall <= '1';
					
				else
					
					NS <= WORK_STATE;
					out_control.stall <= '0';
						
				end if;
			when STOP_STATE =>
				
				NS <= STOP_STATE;
				out_control.stall <= '1';
				out_control.stop <= not in_control.mem_busy;
				
		end case;
	end process comb;
	

end architecture RTL;
