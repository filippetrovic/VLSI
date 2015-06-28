library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

--	Stall generator je SM koja treba da generise 
--	stall signal, signale za validnost instrukcija (ready signal) i go signale.
--	Semantika ready signala je "instrukcija je validna".
--	go signali se vode na switch, i govore mu kada da propusti instrukciju.
entity stall_generator is
	port (
		clk : in std_logic;
		rst : in std_logic;
		in_control: in stall_generator_in_control_t;
		out_control: out stall_generator_out_control_t
	);
end entity stall_generator;

architecture RTL of stall_generator is
--	pomocna funkcija, nista uzbudljivo, samo postavlja ready bite.
	function setReady (fica_ready: std_logic; fedja_ready: std_logic)
		return instruction_ready_array_t is
	
		variable toRet : instruction_ready_array_t;
	begin
		
		toRet(0) := fica_ready;
		toRet(1) := fedja_ready;
		
		return toRet;
	end function setReady;
	
--	takodje pomocna funkcija.
	function setGO (fica_go: std_logic; fedja_go: std_logic)
		return instruction_go_array_t is
	
		variable toRet : instruction_go_array_t;
	begin
		
		toRet(0) := fica_go;
		toRet(1) := fedja_go;
		
		return toRet;
	end function setGO;
	
	
--	stanja odgovaraju tipovima hazarda
	type state is (A, B, C, N);
--	trenutno stanje (PS) i sledece stanje (NS).
	signal PS, NS : state;
begin
	sync : process (clk, rst) is
	begin
		if rst = '1' then
			PS <= N;
		elsif rising_edge(clk) then
			PS <= NS;
		end if;
	end process sync;
	
	comb : process (PS, in_control) is
	begin
--		inicijalno stall je neaktivan.
--		Obratiti paznju da u nastavku koda postoje naredbe samo za invertovanje nekog
--		od signala, znaci ako vidite stall <= '1' i pitate se gde se postavlja
--		stall <= '0', odgovor je ovde. ;)
		out_control.stall <= '0';
		for i in out_control.inst_go'range loop
			out_control.inst_go(i) <= '1';
		end loop;
--		inicijalno su obe instrukcije validne. Ovo ce se promeniti u zavisnosti od stanja.
		for i in out_control.inst_ready'range loop
			out_control.inst_ready(i) <= '1';
		end loop;
		
		
		
--		u zavisnosti od stanja preduzeti neku akciju. 
		case PS is 
			when A =>
				NS <= N;
				out_control.inst_go <= setGO('0','1');
				out_control.inst_ready <= setReady('0','1');
			when B =>
				out_control.inst_ready <= setReady('0','1');
				if (in_control.mem_done = '1') then
					NS <= N;
					out_control.inst_go <= setGO('0','1');
				else
					out_control.stall <= '1';
					NS <= B;
					out_control.inst_go <= setGO('0','0');
				end if;
			when C =>
				out_control.inst_ready <= setReady('1','1');
				if (in_control.mem_done = '1') then
					NS <= N;
					out_control.inst_go <= setGO('1','1');
				else
					out_control.stall <= '1';
					NS <= C;
					out_control.inst_go <= setGO('0','0');
				end if;
			when N =>
				out_control.inst_ready <= setReady('1','1');
				out_control.inst_go <= setGO('1','1');
				case in_control.haz_type is
					when A_type =>
						out_control.stall <= '1';
						NS <= A;
						out_control.inst_go <= setGO('1','0');
					when B_type =>
						out_control.stall <= '1';
						NS <= B;
						out_control.inst_go <= setGO('1','0');
					when C_type =>
						out_control.stall <= '1';
						NS <= C;
						out_control.inst_go <= setGO('0','0');
					when No_hazard =>
						NS <= N;
						out_control.inst_go <= setGO('1','1');
				end case;
		end case;
		
	end process comb;

end architecture RTL;
