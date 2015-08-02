library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

--	hazard detektor je entitet koji izlaznim signalom haz_type
--	signalizira stall generatoru da je doslo do hazarda.
--	Hazardi su opisani u dokumentu na google drive.
entity hazard_detector is
	port(
		in_data     : in  haz_detector_in_data_t;
		in_control  : in  haz_detector_in_control_t;
		out_control : out haz_detector_out_control_t
	);
end entity hazard_detector;

architecture RTL of hazard_detector is
--	ovaj tip je niz boolean vrednosti
	type boolean_array_t is array (0 to ISSUE_WIDTH - 1) of boolean;

--	tip instrukcije. Koristi se u logici za hazarde
	type inst_kind_t is (ALU_INST, BR_INST, MEM_INST, UNKNOWN);
	type inst_kind_array_t is array (0 to ISSUE_WIDTH - 1) of inst_kind_t;

--	funkcija koja na osnovu op koda vraca tip instrukcije .
	function get_inst_kind(op : mnemonic_t) return inst_kind_t is
	begin
		case to_integer(unsigned(op)) is
			when to_integer(unsigned(AND_M)) to to_integer(unsigned(SIMOV_M)) =>
				return ALU_INST;
			when to_integer(unsigned(LOAD_M)) | to_integer(unsigned(STORE_M)) =>
				return MEM_INST;
			when to_integer(unsigned(BEQ_M)) to to_integer(unsigned(BLAL_M)) =>
				return BR_INST;
			when others =>
				return UNKNOWN;
		end case;
	end function get_inst_kind;
	
--	funkcija koja vraca bool u zavisnosti da li je instrukcija imm ili ne
	function get_inst_imm(op : mnemonic_t) return boolean is
	begin
		if op = IMOV_M or op = SIMOV_M then
			return true;
		else
			return false;
		end if;
	end function get_inst_imm;
	
--	funkcija koja vraca bool u zavisnosti da li instrukcija koristi r1
	function use_r1 (op : mnemonic_t) return boolean is
	begin
		if op = NOT_M or op = MOV_M or op = SIMOV_M or op = IMOV_M then
			return false;
		else
			return true;
		end if;
	end function use_r1;
	
	
begin
	detector : process (in_data, in_control) is
		variable inst_kind          : inst_kind_array_t;
--		boolean flag koji oznacava da li je Fedja imm instrukcija. 
--		Ako jeste onda on ne koristi r2. 
		variable inst_imm			: boolean_array_t;
--		da li je instrukcija validna po oba kriterijuma (po SM i ID signalima)
		variable inst_valid         : boolean_array_t;
--		da li instrukcija menja psw
		variable inst_1_changes_psw : boolean;
--		da li instrukcija cita psw
		variable inst_2_reads_psw 	: boolean;
--		da li instrukcija koristi r1
		variable inst_use_r1		: boolean_array_t;	
	begin
--		inicijalizacija promenljivih
--		validnost je AND signala valid iz SM i ID
		for i in inst_valid'range loop
			inst_valid(i) := std2bool(in_data.instructions(i).valid and in_control.inst_ready(i));
		end loop;

--		tip instrukcije na osnovu op koda
		for i in inst_kind'range loop
			inst_kind(i) := get_inst_kind(in_data.instructions(i).op);
		end loop;

--		Instrukcija je imm ako ima odgovarajuci op kod.
		for i in inst_imm'range loop
			inst_imm(i) := get_inst_imm(in_data.instructions(i).op);
		end loop;

--		Instrukcija koristi r1 ako nije neki MOV ili nije NOT
		for i in inst_use_r1'range loop
			inst_use_r1(i) := use_r1(in_data.instructions(i).op);
		end loop;

--		psw menjaju sve instrukcije od SUB do SSBC.
		case to_integer(unsigned(in_data.instructions(0).op)) is
			when to_integer(unsigned(SUB_M)) to to_integer(unsigned(SSBC_M)) =>
				inst_1_changes_psw := true;
			when others =>
				inst_1_changes_psw := false;
		end case;
		
--		psw citaju ALU instrukcije sa odgovarajucim op code i BR instrukcije.
		case to_integer(unsigned(in_data.instructions(1).op)) is
			when to_integer(unsigned(ADC_M)) | to_integer(unsigned(SBC_M)) | 
				to_integer(unsigned(SADC_M)) | to_integer(unsigned(SSBC_M)) =>
					
					inst_2_reads_psw := true;
					
			when to_integer(unsigned(BEQ_M)) to to_integer(unsigned(BLAL_M)) =>
				
					inst_2_reads_psw := true;
				
			when others =>
					inst_2_reads_psw := false;
		end case;
--		kraj inicijalizacije promenljivih

--		if-elsif-else konstrukt za detekciju hazarda. Hazardi su poredjani po priortetima.
		if inst_valid(0) and inst_valid(1) and in_control.mem_load = '1' and inst_kind(0) = ALU_INST and
			((in_data.instructions(0).r1 = in_control.mem_reg and inst_use_r1(0) = true) or 
			(in_data.instructions(0).r2 =  in_control.mem_reg and inst_imm(0) = false) or
			in_data.instructions(0).r3 =  in_control.mem_reg) then
			
			--	hazard tip C 1 (samo za Fica je alu instrukcija)
			out_control.haz_type <= C_type;
				
		elsif inst_valid(0) and inst_valid(1) and in_control.mem_load = '1' and 
			in_data.instructions(0).op = BLAL_M and
			in_control.mem_reg = std_logic_vector(to_unsigned(31,reg_num_t'length)) then
			
			--	hazard tip C 1 (samo za Fica je BR instrukcija koja pise u link registar)
			out_control.haz_type <= C_type;
		
		elsif inst_valid(0) and inst_valid(1) and in_control.mem_busy = '1' and inst_kind(0) = MEM_INST then
			
			-- hazard tip C 2
			out_control.haz_type <= C_Type;
			
		elsif inst_valid(0) and inst_valid(1) and in_data.instructions(0).op = LOAD_M and inst_kind(1) = ALU_INST and 
			((in_data.instructions(0).r3 = in_data.instructions(1).r1 and inst_use_r1(1) = true) or 
			(in_data.instructions(0).r3 = in_data.instructions(1).r2 and inst_imm(1) = false) or 
			in_data.instructions(0).r3 = in_data.instructions(1).r3) then
		
			--	hazard tip B 1 (samo kada je Fedja ALU)
			--	(ovo potencijalno javlja hazard i za CMP, sto ne mora, ali ne skodi)
			out_control.haz_type <= B_type;
		
		elsif inst_valid(0) and inst_valid(1) and in_data.instructions(0).op = LOAD_M and 
			in_data.instructions(1).op = BLAL_M and 
			in_data.instructions(0).r3 = std_logic_vector(to_unsigned(31,reg_num_t'length)) then
			
			--	hazard tip B 1 (samo kada je Fedja BR koji pise u link registar)
			out_control.haz_type <= B_type;
		
		elsif inst_valid(0) and inst_valid(1) and inst_kind(0) = MEM_INST and inst_kind(1) = MEM_INST then
		
			--	hazard tip B 2
			out_control.haz_type <= B_type;
			
		elsif inst_valid(0) and inst_valid(1) and in_control.mem_load = '1' and inst_kind(1) = ALU_INST and
			((in_data.instructions(1).r1 = in_control.mem_reg and inst_use_r1(1) = true) or 
			(in_data.instructions(1).r2 =  in_control.mem_reg and inst_imm(1) = false) or
			in_data.instructions(1).r3 =  in_control.mem_reg) then
			
			--	hazard tip B 3 (samo za Fedja alu instrukcija)
			out_control.haz_type <= B_type;
				
		elsif inst_valid(0) and inst_valid(1) and in_control.mem_load = '1' and 
			in_data.instructions(1).op = BLAL_M and
			in_control.mem_reg = std_logic_vector(to_unsigned(31,reg_num_t'length)) then
			
			--	hazard tip B 3 (samo za Fedja BR instrukcija koja pise u link registar)
			out_control.haz_type <= B_type;
			
		elsif inst_valid(0) and inst_valid(1) and in_control.mem_busy = '1' and inst_kind(1) = MEM_INST then
		
			--	hazard tip B 4
			out_control.haz_type <= B_type;
			
		elsif inst_valid(0) and inst_valid(1) and inst_kind(0) = ALU_INST and 
			in_data.instructions(0).op /= CMP_M and
			((in_data.instructions(0).r3 = in_data.instructions(1).r1 and inst_use_r1(1) = true) or 
			(in_data.instructions(0).r3 = in_data.instructions(1).r2 and inst_imm(1) = false)) then									
				
			--	hazard tip A 1
			out_control.haz_type <= A_type;
		
		elsif inst_valid(0) and inst_valid(1) and inst_1_changes_psw and inst_2_reads_psw then
			
			--	hazard tip A 2
			out_control.haz_type <= A_type;
				
		elsif inst_valid(0) and inst_valid(1) and inst_kind(0) = BR_INST then
			
			--	hazard tip A 3
			out_control.haz_type <= A_type;
				
		else
			
			--	nema hazarda - default vrednost
			out_control.haz_type <= No_hazard;
			
		end if;

	end process detector;

end architecture RTL;
