library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package vlsi_pkg is 
	constant ISSUE_WIDTH : integer := 2;
	constant ALU_FUNC_NUM : integer := 2;
	
	subtype address_t is std_logic_vector(31 downto 0);

	type address_array_t is array (0 to ISSUE_WIDTH - 1) of address_t;

	subtype word_t is std_logic_vector(31 downto 0);

	type word_array_t is array (0 to ISSUE_WIDTH - 1) of word_t;
	
--	if stage types:

	type undecoded_instruction_t is record
		pc: address_t;
		instruction: word_t;
		valid: std_logic;
	end record undecoded_instruction_t;

	type undecoded_instruction_array_t is array(0 to ISSUE_WIDTH-1) of undecoded_instruction_t;

	type if_data_in_t is record
		jump_address: address_t;
		mem_values: word_array_t;
	end record if_data_in_t;
	
	type if_data_out_t is record
		mem_address: address_array_t;
		instructions: undecoded_instruction_array_t;
	end record if_data_out_t;
	
	type if_control_in_t is record
		jump: std_logic;
		stall: std_logic;
	end record if_control_in_t;
	
	type if_control_out_t is record
		read: std_logic;
	end record if_control_out_t;
	
--	if stage types end
	
--	ID stage types

	type id_data_in_t is record
		instructions: undecoded_instruction_array_t;
	end record id_data_in_t;
	
	type id_control_in_t is record
		stall: std_logic;
		jump: std_logic;
	end record id_control_in_t;
	
	type id_control_out_t is record
		stall: std_logic;
	end record id_control_out_t;
	
	subtype mnemonic_t is std_logic_vector(4 downto 0);
--	instruckcije za obradu podataka
	constant AND_M : mnemonic_t := "00000";
	constant SUB_M : mnemonic_t := "00001";
	constant ADD_M : mnemonic_t := "00010";
	constant ADC_M : mnemonic_t := "00011";
	constant SBC_M : mnemonic_t := "00100";
	constant CMP_M : mnemonic_t := "00101";
	constant SSUB_M : mnemonic_t := "00110";
	constant SADD_M : mnemonic_t := "00111";
	constant SADC_M : mnemonic_t := "01000";
	constant SSBC_M : mnemonic_t := "01001";
	constant MOV_M : mnemonic_t := "01010";
	constant NOT_M : mnemonic_t := "01011";
	constant SL_M : mnemonic_t := "01100";
	constant SR_M : mnemonic_t := "01101";
	constant ASR_M : mnemonic_t := "01110";
--	instrukcije za obradu podataka sa neposrednim operandom
	constant IMOV_M : mnemonic_t := "01111";
	constant SIMOV_M : mnemonic_t := "10000";
--	laod/store
	constant LOAD_M : mnemonic_t := "10100";
	constant STORE_M : mnemonic_t := "10101";
--	instrukcije skoka
	constant BEQ_M : mnemonic_t := "11000";
	constant BGT_M : mnemonic_t := "11001";
	constant BHI_M : mnemonic_t := "11010";
	constant BAL_M : mnemonic_t := "11011";
	constant BLAL_M : mnemonic_t := "11100";
--	stop instrukcija
	constant STOP_M : mnemonic_t := "11111";
--	error (invalid opcode)
	constant ERROR_M : mnemonic_t := "10001";
	
	subtype reg_num_t is std_logic_vector(4 downto 0);
	subtype immediate_t is std_logic_vector(16 downto 0);
	subtype jump_offset_t is std_logic_vector(26 downto 0);
	
	type decoded_instruction_t is record
		pc: address_t;
		op: mnemonic_t;
		r1: reg_num_t;
		r2: reg_num_t;
		r3: reg_num_t;
		imm: immediate_t;
		offset: jump_offset_t;
		valid: std_logic;
	end record decoded_instruction_t;
	
	type decoded_instruction_array_t is array(0 to ISSUE_WIDTH-1) of decoded_instruction_t;
	
	type id_data_out_t is record
		instructions: decoded_instruction_array_t;
	end record id_data_out_t;
	
--	ID stage types end
	
--	RegFile types and constants
--	sirina za adresu	
	constant NUM_OF_REG_LOG : integer := 5;
	
--	sirina registra
	constant REGISTER_WIDTH : integer := 32;
	
--	broj linija za citanje
	constant READ_LINES_NUM : integer := 4;
	
--	broj linija za upis
	constant WRITE_LINES_NUM : integer := 4;
	
--	ovaj tip predstavlja adresu sa koje se cita
	subtype reg_address is std_logic_vector(NUM_OF_REG_LOG - 1 downto 0);
	
--	ovaj tip predstavlja jedan registar
	subtype gp_register is std_logic_vector(REGISTER_WIDTH - 1 downto 0);
	
--	32 registra opste namene
	type registers is array(0 to 31) of gp_register;
	
--	READ_LINES_NUM linija za adresu za citanje
	type read_address_array_t is array(0 to READ_LINES_NUM - 1) of reg_address;
	
--	READ_LINES_NUM linija za procitanu vrednost
	type grp_output_value_t is array (0 to READ_LINES_NUM - 1) of gp_register;
	
--	adresa, vrednost i write signal za jedan upis
	type write_data_t is record
		address: reg_address;
		value: gp_register;
		write: std_logic;
	end record write_data_t;
	
--	WRITE_LINES_NUM ulaza za upis
	type write_data_array_t is array(0 to WRITE_LINES_NUM - 1) of write_data_t;
	
	
--	svi ulazni podaci u registartski fajl
	type gpr_in_data_t is record
		read_address: read_address_array_t;
		write_data_arr: write_data_array_t;
	end record gpr_in_data_t;
	
--	svi izlazni podaci (linije) iz registarskog fajla
	type gpr_out_data_t is record
		value: grp_output_value_t;
	end record gpr_out_data_t;
	
--	RegFile types and constants end

--	WriteSinhUnit types and constants
	
--	ocekivani ulaz u wsh. addresa je "adresa" registra, njegov redni broj.
--	value je vrednost, pc je pc instrukcije koja je izgenerisala vrednost.	
	type wsh_in_data_t is record
		address: reg_address;
		value: gp_register;
		pc: address_t;
		valid: std_logic;
	end record wsh_in_data_t;
	
	type wsh_in_data_array_t is array(0 to WRITE_LINES_NUM - 1) of wsh_in_data_t;
	
--	WriteSinhUnit types and constants end

--	Switch types and constants

--	Svi hazardi su svrstani u tri kategorije. SM (stall generator je projektovana po ovom uzoru).
--	Pogledati SM dijagram za stall generator.
	type hazard_type is (A_type, B_type, C_type, No_hazard);
	
--	Switch-u je dovoljno da zna op code i da li je instrukcija validna, kao i da li je doslo do nekog hazarda,
--	da bi mogao da generise "go" signal za neku func jedinicu.
	
	type switch_in_data_t is record
		instructions: decoded_instruction_array_t;
--		haz_type: hazard_type; Revizija: Sada se koristi samo ready signal iz SM 
	end record switch_in_data_t;

--	Ovim tipom se oznacava da li Fica i Fedja idu u func jedinicu.
--	Ako je vrednost '1' onda instrukciju treba proslediti u func jedinicu.
--	Detaljnije je je objasnjeno u readme u odeljku 'Stall Genarator'.
	type instruction_go_array_t is array(0 to ISSUE_WIDTH-1) of std_logic;

--	ulazni tip.
--	inst_go je inst_ready iz SM, i oznacava kada propustiti instrukciju na func jedinicu.
	type switch_in_control_t is record
		inst_go: instruction_go_array_t;
	end record switch_in_control_t;
	
	
--	izlaz switch-a i ulaz u func jedinicu. Switch prosledjuje dekodovani instrukciju i go signal.
	type func_unit_input_control_t is record
		instruction: decoded_instruction_t;
		go: std_logic;
	end record func_unit_input_control_t;
	
	type func_unit_input_control_array_t is array(0 to ALU_FUNC_NUM - 1) of func_unit_input_control_t;

--	Svaki od cinilaca rekorda se vodi na odgovarajucu func jedinicu. Signal '1' oznacava da func ima validne
--	vrednosti na svojim ulazima i da treba da pocne sa izvrsavanjem.	
	type switch_out_data_t is record
		alu_control: func_unit_input_control_array_t;
		br_control: func_unit_input_control_t;
		mem_control: func_unit_input_control_t;
	end record switch_out_data_t;
	
--	Switch types and constants end

--	JZP types and constants
	
--	Ulazni tip podataka za jzp. Linije "from_wsu" dolaze iz WriteSinhUnit,
--	dok linije "from_gpr" predstavljaju jedan izlaz GPR.
--	"address" je adresa registra za koji se razmatra prosledjivanje.
	type jzp_in_data_t is record
		from_wsu: write_data_array_t;
		from_gpr: gp_register;
		address: reg_address;
	end record jzp_in_data_t;
	
--	Izlazni tip podataka za jzp. "out_value" je (aktuelna) vrednost registra,
--	tj. ono sto jzp prosledjuje na izlaz.
--	"address" je samo prosledjena vrednost "address" bez transformacija.
	type jzp_out_data_t is record
		out_value: gp_register;
		address: reg_address;
	end record jzp_out_data_t;
	
--	JZP types and constants end

--	Stall_generator types and constants
	
--	Ulazni signali za SM (u daljem tekstu SM = stall generator). "haz_type" dolazi iz
--	hazard detector-a i oznacava tip hazarda koji je detektovan. "mem_done" dolazi iz MEM.
	type stall_generator_in_control_t is record
		haz_type: hazard_type;
		mem_done: std_logic;
	end record stall_generator_in_control_t;
	
--	"stall" je izlazni signal i sluzi za blokiranje frontend-a.
--	inst_ready je signal koji se generise ovde (SM) i u odnosu na njega
--	switch propusta na func jedinicu ili ne propusta.
	type stall_generator_out_control_t is record
		stall : std_logic;
		inst_ready: instruction_go_array_t;	
	end record stall_generator_out_control_t;
	
--	Stall_generator types and constants end

--	General Purpose functions
	function unsigned_add(data : std_logic_vector; increment : natural) return std_logic_vector;
	function bool2std_logic(bool : boolean) return std_logic;
end package vlsi_pkg;

package body vlsi_pkg is
	function unsigned_add(data : std_logic_vector; increment : natural) return std_logic_vector is
		variable ret : std_logic_vector(data'range);
	begin
		if (is_X(data)) then
			ret := data;
		else
			ret := std_logic_vector(unsigned(data) + to_unsigned(increment, data'length));
		end if;
		return ret;
	end function unsigned_add;
	
	function bool2std_logic(bool : boolean)
		return std_logic is
	begin
		if bool then
			return '1';
		else
			return '0';
		end if;
	end function bool2std_logic;
	
	
end package body vlsi_pkg;
