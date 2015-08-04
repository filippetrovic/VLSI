library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package vlsi_pkg is
	constant ISSUE_WIDTH  : integer := 2;
	constant ALU_FUNC_NUM : integer := 2;

	constant WORD_WIDTH : positive := 32;
	constant ADDR_WIDTH : positive := 32;
	constant CLK_PERIOD : time     := 10 ns;

	subtype address_t is std_logic_vector(31 downto 0);

	type address_array_t is array (0 to ISSUE_WIDTH - 1) of address_t;

	subtype word_t is std_logic_vector(31 downto 0);

	type word_array_t is array (0 to ISSUE_WIDTH - 1) of word_t;

	type undecoded_instruction_t is record
		pc          : address_t;
		instruction : word_t;
		valid       : std_logic;
	end record undecoded_instruction_t;

	type undecoded_instruction_array_t is array (0 to ISSUE_WIDTH - 1) of undecoded_instruction_t;

	-- IF STAGE types

	type if_control_in_t is record
		stall : std_logic;
		jump  : std_logic;
	end record if_control_in_t;

	type if_data_in_t is record
		init_pc      : address_t;
		jump_address : address_t;
		mem_values   : word_array_t;
	end record if_data_in_t;

	type if_control_out_t is record
		read : std_logic;
	end record if_control_out_t;

	type if_data_out_t is record
		addresses    : address_array_t;
		instructions : undecoded_instruction_array_t;
	end record if_data_out_t;

	-- IF STAGE types end

	--	RegFile types and constants
	--	sirina za adresu	
	constant NUM_OF_REG_LOG : integer := 5;

	--	sirina registra
	constant REGISTER_WIDTH : integer := 32;

	--	broj linija za citanje
	constant GPR_READ_LINES_NUM : integer := 6;

	--	broj linija za upis
	constant WRITE_LINES_NUM : integer := 4;

	--	ovaj tip predstavlja adresu registra
	subtype reg_address is std_logic_vector(NUM_OF_REG_LOG - 1 downto 0);

	--	ovaj tip predstavlja jedan registar
	subtype gp_register is std_logic_vector(REGISTER_WIDTH - 1 downto 0);

	--	32 registra opste namene
	type registers is array (0 to 31) of gp_register;

	--	READ_LINES_NUM linija za adresu za citanje
	type read_address_array_t is array (0 to GPR_READ_LINES_NUM - 1) of reg_address;

	--	READ_LINES_NUM linija za procitanu vrednost
	type grp_output_value_array_t is array (0 to GPR_READ_LINES_NUM - 1) of gp_register;

	--	adresa, vrednost i write signal za jedan upis
	type write_data_t is record
		address : reg_address;
		value   : gp_register;
		write   : std_logic;
	end record write_data_t;

	--	WRITE_LINES_NUM ulaza za upis
	type write_data_array_t is array (0 to WRITE_LINES_NUM - 1) of write_data_t;

	--	svi ulazni podaci u registartski fajl
	type gpr_in_data_t is record
		read_address   : read_address_array_t;
		write_data_arr : write_data_array_t;
	end record gpr_in_data_t;

	--	svi izlazni podaci (linije) iz registarskog fajla
	type gpr_out_data_t is record
		value : grp_output_value_array_t;
	end record gpr_out_data_t;

	--	RegFile types and constants end


	-- ID STAGE types

	type id_data_in_t is record
		instructions : undecoded_instruction_array_t;
	end record id_data_in_t;

	type id_control_in_t is record
		stall : std_logic;
		jump  : std_logic;
	end record id_control_in_t;

	type id_control_out_t is record
		stall : std_logic;
	end record id_control_out_t;

	subtype mnemonic_t is std_logic_vector(4 downto 0);
	--	instruckcije za obradu podataka
	constant AND_M   : mnemonic_t := "00000";
	constant SUB_M   : mnemonic_t := "00001";
	constant ADD_M   : mnemonic_t := "00010";
	constant ADC_M   : mnemonic_t := "00011";
	constant SBC_M   : mnemonic_t := "00100";
	constant CMP_M   : mnemonic_t := "00101";
	constant SSUB_M  : mnemonic_t := "00110";
	constant SADD_M  : mnemonic_t := "00111";
	constant SADC_M  : mnemonic_t := "01000";
	constant SSBC_M  : mnemonic_t := "01001";
	constant MOV_M   : mnemonic_t := "01010";
	constant NOT_M   : mnemonic_t := "01011";
	constant SL_M    : mnemonic_t := "01100";
	constant SR_M    : mnemonic_t := "01101";
	constant ASR_M   : mnemonic_t := "01110";
	--	instrukcije za obradu podataka sa neposrednim operandom
	constant IMOV_M  : mnemonic_t := "01111";
	constant SIMOV_M : mnemonic_t := "10000";
	--	laod/store
	constant LOAD_M  : mnemonic_t := "10100";
	constant STORE_M : mnemonic_t := "10101";
	--	instrukcije skoka
	constant BEQ_M   : mnemonic_t := "11000";
	constant BGT_M   : mnemonic_t := "11001";
	constant BHI_M   : mnemonic_t := "11010";
	constant BAL_M   : mnemonic_t := "11011";
	constant BLAL_M  : mnemonic_t := "11100";
	--	stop instrukcija
	constant STOP_M  : mnemonic_t := "11111";
	--	error (invalid opcode)
	constant ERROR_M : mnemonic_t := "10001";

	subtype immediate_t is std_logic_vector(16 downto 0);
	subtype jump_offset_t is std_logic_vector(26 downto 0);

	type decoded_instruction_t is record
		pc     : address_t;
		op     : mnemonic_t;
		r1     : reg_address;
		r2     : reg_address;
		r3     : reg_address;
		imm    : immediate_t;
		offset : jump_offset_t;
		valid  : std_logic;
	end record decoded_instruction_t;

	type decoded_instruction_array_t is array (0 to ISSUE_WIDTH - 1) of decoded_instruction_t;

	type id_data_out_t is record
		instructions : decoded_instruction_array_t;
	end record id_data_out_t;

	--	ID stage types end

	--	WriteSinhUnit types and constants

	--	ocekivani ulaz u wsh. addresa je "adresa" registra, njegov redni broj.
	--	value je vrednost, pc je pc instrukcije koja je izgenerisala vrednost.	
	type wsh_in_data_t is record
		address : reg_address;
		value   : gp_register;
		pc      : address_t;
		valid   : std_logic;
	end record wsh_in_data_t;

	type wsh_in_data_array_t is array (0 to WRITE_LINES_NUM - 1) of wsh_in_data_t;

	--	WriteSinhUnit types and constants end

	--	Switch types and constants

	--	Svi hazardi su svrstani u tri kategorije. SM (stall generator je projektovana po ovom uzoru).
	--	Pogledati SM dijagram za stall generator.
	type hazard_type is (A_type, B_type, C_type, No_hazard);

	--	Switch-u je dovoljno samo da zna op code da bi mogao da aktivira func jedinicu.
	--	Takodje kroz in_control signale dobija kontrolni signal kada da propusti instrukciju.
	type switch_in_data_t is record
		instructions : decoded_instruction_array_t;
	--		haz_type: hazard_type; Revizija: Sada se koristi samo go signal iz SM 
	end record switch_in_data_t;

	--	Ovim tipom se oznacava da li Fica i Fedja idu u func jedinicu.
	--	Ako je vrednost '1' onda instrukciju treba proslediti u func jedinicu.
	--	Detaljnije je je objasnjeno u readme u odeljku 'Stall Genarator'.
	type instruction_go_array_t is array (0 to ISSUE_WIDTH - 1) of std_logic;

	--	ulazni tip.
	--	inst_go je inst_ready iz SM, i oznacava kada propustiti instrukciju na func jedinicu.
	type switch_in_control_t is record
		inst_go : instruction_go_array_t;
	end record switch_in_control_t;

	--	izlaz switch-a i ulaz u func jedinicu. Switch prosledjuje dekodovani instrukciju i go signal.
	type func_unit_input_control_t is record
		instruction : decoded_instruction_t;
		go          : std_logic;
	end record func_unit_input_control_t;

	type func_unit_input_control_array_t is array (0 to ALU_FUNC_NUM - 1) of func_unit_input_control_t;

	--	Svaki od cinilaca rekorda se vodi na odgovarajucu func jedinicu. Signal '1' oznacava da func ima validne
	--	vrednosti na svojim ulazima i da treba da pocne sa izvrsavanjem.	
	type func_units_control_t is record
		alu_control : func_unit_input_control_array_t;
		br_control  : func_unit_input_control_t;
		mem_control : func_unit_input_control_t;
	end record func_units_control_t;
	
	--	Izlazni podaci iz switcha. registri se vode na JZP, a func_control na backend.	
	type switch_out_data_t is record
		func_control : func_units_control_t;
		r1           : reg_address;
		r3           : reg_address;
	end record switch_out_data_t;

	--	Switch types and constants end

	--	JZP types and constants

	--	Ulazni tip podataka za jzp. Linije "from_wsu" dolaze iz WriteSinhUnit,
	--	dok linije "from_gpr" predstavljaju jedan izlaz GPR.
	--	"address" je adresa registra za koji se razmatra prosledjivanje.
	type jzp_in_data_t is record
		from_wsu : write_data_array_t;
		from_gpr : gp_register;
		address  : reg_address;
	end record jzp_in_data_t;

	--	Izlazni tip podataka za jzp. "out_value" je (aktuelna) vrednost registra,
	--	tj. ono sto jzp prosledjuje na izlaz.
	type jzp_out_data_t is record
		out_value : gp_register;
	end record jzp_out_data_t;

	--	JZP types and constants end

	--	Stall_generator types and constants

	--	Ulazni signali za SM (u daljem tekstu SM = stall generator). "haz_type" dolazi iz
	--	hazard detector-a i oznacava tip hazarda koji je detektovan. "mem_done" dolazi iz MEM.
	type stall_generator_in_control_t is record
		haz_type : hazard_type;
		mem_done : std_logic;
	end record stall_generator_in_control_t;

	--	Ovim tipom ce biti predstavljeno da li je instrukcija i dalje validna.
	--	Moze se desiti da je fica validan ako se gleda ID faza, ali je zbog Fedje doslo do hazarda,
	-- 	tako da je Fica propustan, a Fedja zadrzan. Kada se ispune uslovi da Fedja moze da se izvrsi,
	--	treba znati da je Fica vec obradjen. E tada ce ovaj tip (niz) imati vrednosti (0,1);
	type instruction_ready_array_t is array (0 to ISSUE_WIDTH - 1) of std_logic;

	--	"stall" je izlazni signal i sluzi za blokiranje frontend-a.
	--	inst_go je signal koji se generise ovde (SM) i u odnosu na njega
	--	switch propusta na func jedinicu ili ne propusta.
	--	inst_ready je opisan iznad, vodi se na Hazard detector da bi bio svestan ako je jedna instrukcija
	--	blokirana a prva propustena, da u sledecem taktu ne gleda prvu instrkuciju (onu koja je vec propustena)
	type stall_generator_out_control_t is record
		stall      : std_logic;
		inst_go    : instruction_go_array_t;
		inst_ready : instruction_ready_array_t;
	end record stall_generator_out_control_t;

	--	Stall_generator types and constants end

	--	PSW types and constants
	--	PSW je entitet koji sadrzi dva entiteta: psw registar i sinhronizaciju upisa.

	--	ovim tipom se opisuje psw registar. N, Z, C i V su najvisa 4 bita.
	subtype psw_register_t is std_logic_vector(31 downto 0);

	--	konstante koje oznacavaju gde se koji bit nalazi u psw.
	constant N_POSITION : integer := 31;
	constant Z_POSITION : integer := 30;
	constant C_POSITION : integer := 29;
	constant V_POSITION : integer := 28;

	--	jedan element ulaznih linija u psw synch.
	--	psw_value je nova vrednost za psw koju generise ALU.
	--	update_psw je signal koji aktivnom vrednoscu oznacava da je ALU generisao novi psw
	--	(postoje ALU instrukcije koje ne generisu psw).
	type psw_synch_in_data_t is record
		psw_value  : psw_register_t;
		update_psw : std_logic;
	end record psw_synch_in_data_t;

	--	ulazne linije u psw synch.
	type psw_synch_in_data_array_t is array (0 to ALU_FUNC_NUM - 1) of psw_synch_in_data_t;

	--	PSW types and constants end	

	--	Hazard detector types and constants

	--	ulazni podaci su dekodovane instrukcije.
	type haz_detector_in_data_t is record
		instructions : decoded_instruction_array_t;
	end record haz_detector_in_data_t;

	--	inst_ready su ready signali iz SM
	--	mem_active je signal iz MEM bloka koji oznacava da je MEM blok zauzet.
	--	mem_reg je registar u koji se dovlaci vrednost iz memorije.	
	type haz_detector_in_control_t is record
		inst_ready : instruction_ready_array_t;
		mem_busy   : std_logic;
		mem_load   : std_logic;
		mem_reg    : reg_address;
	end record haz_detector_in_control_t;

	--	izlazni signal je tip hazarda koji se vodi na ulaz SM.	
	type haz_detector_out_control_t is record
		haz_type : hazard_type;
	end record haz_detector_out_control_t;

	--	Hazard detector types and constants end

	--	Branch unit types and constants

	type branch_unit_data_in_t is record
		psw         : psw_register_t;
		instruction : decoded_instruction_t;
	end record branch_unit_data_in_t;

	type branch_unit_data_out_t is record
		jump_address : address_t;
		link_address : address_t;
		pc : address_t;
	end record branch_unit_data_out_t;

	type branch_unit_control_in_t is record
		go : std_logic;
	end record branch_unit_control_in_t;

	type branch_unit_control_out_t is record
		jump : std_logic;
		wr   : std_logic;
	end record branch_unit_control_out_t;

	--	Branch unit types and constants end

	--	ALU unit types

	type alu_in_data_t is record
		instruction : decoded_instruction_t;
		operand_A   : jzp_out_data_t;
		operand_B   : jzp_out_data_t;
		psw         : psw_register_t;
	end record alu_in_data_t;

	type alu_in_control_t is record
		go : std_logic;
	end record alu_in_control_t;

	type alu_out_data_t is record
		result : wsh_in_data_t;
		psw    : psw_synch_in_data_t;
	end record alu_out_data_t;

	--	ALU unit types end	

	--	Middle - control types and constants	
	
	--	ulazni tip za Middle. 
	--	from_id su linije sa Frontenda, from_wsu su linije iz backenda, tacnije WSU.	
	type middle_in_data_t is record
		from_id : id_data_out_t;
		from_wsu : write_data_array_t;
	end record middle_in_data_t;
	
	-- ulazne kontrolne linije za middle.
	--	TODO: Treba prebaciti na tip koriscen u mem_unit.		
	type middle_in_control_t is record
		mem_busy : std_logic;
		mem_load : std_logic;
		mem_done : std_logic;
		mem_reg : reg_address;
	end record middle_in_control_t;
	
	--	Izlazni kontrolni signali.
	--	stall se vodi na frontend.	
	type middle_out_control_t is record
		stall : std_logic;
		stop : std_logic;
	end record middle_out_control_t;
	
	type jzp_out_data_array_t is array(0 to GPR_READ_LINES_NUM - 1) of jzp_out_data_t;
	
	-- Izlazne linije podataka.
	--	func_control su linije koje idu sa Swtich-a, tamo su opisane.
	--	operand_values su linije koje idu sa JPZ-ova. Niz operanada za func jedinice.	
	type middle_out_data_t is record
		func_control : func_units_control_t;
		operand_values : jzp_out_data_array_t;
	end record middle_out_data_t;
	
	--	Middle - control types and constants end
	
	--	Mem unit types

	type mem_unit_data_in_t is record
		instruction : decoded_instruction_t;
		-- vrednost iz registra koja se prosledjuje kroz JZP
		-- ne treba nam ceo izlaz iz JZP zato sto imamo dekodovanu instrukciju
		reg_value   : gp_register;
		-- adresa iz registra R1 koja je prosledjena kroz JZP
		address     : gp_register;
		-- podatak koji je procitan iz memorije
		data        : word_t;
	end record mem_unit_data_in_t;

	type mem_unit_control_in_t is record
		go : std_logic;
	end record mem_unit_control_in_t;

	type mem_unit_control_out_t is record
		-- signali ka hazard detektoru
		mem_load : std_logic;
		mem_busy : std_logic;
		-- traje jedan takt nakon sto se ukine signal mem_busy
		-- vodi se na stall generator
		mem_done : std_logic;
		-- signali ka memoriji podataka
		rd       : std_logic;
		wr       : std_logic;
	end record mem_unit_control_out_t;

	type mem_unit_data_out_t is record
		-- adresa registra sa kojim radimo
		mem_reg  : reg_address;
		-- adresa za adresiranje memorije
		address  : address_t;
		-- podatak za upis
		data     : word_t;
		-- podaci koji se vode na ulaz WSU
		wsu_data : wsh_in_data_t;
	end record mem_unit_data_out_t;

	--	Mem unit types end
	
	--	Stopko types
	
	type stopko_instruction_t is record
		op    : mnemonic_t;
		valid : std_logic;
	end record stopko_instruction_t;
	
	type stopko_instruction_array_t is array(0 to ISSUE_WIDTH - 1) of stopko_instruction_t;
	
	
	type stopko_in_data_t is record
		instructions : stopko_instruction_array_t;
	end record stopko_in_data_t;
	
	type stopko_in_control_t is record
		mem_busy : std_logic;
	end record stopko_in_control_t;
	
	type stopko_out_control_t is record
		stop : std_logic;
		stall : std_logic;
	end record stopko_out_control_t;
	
	--	Stopko types end
	
	--	CPU types
	
	type cpu_in_data_t is record
		--	inicijalni pc od koga krece izvrsavanje
		init_pc      : address_t;
		--	sirove instrukcije koje stizu iz instrukcijskog kesa
		mem_values   : word_array_t;
		--	podatak koji stize iz kesa podataka
		mem_data : word_t;
	end record cpu_in_data_t;
	
	type cpu_out_control_t is record
		--	signal kojim se inst. kesu trazi citanje
		read_inst : std_logic;
		--	signal koji oznacava da je procesor izvrsio stop instrukciju
		stop : std_logic;
		--	signal kojim se trazi citanje od kesa podataka
		read_data : std_logic;
		--	signal kojim se kesu podataka sopstava da treba da upise podatak
		write_data : std_logic;
	end record cpu_out_control_t;
	
	type cpu_out_data_t is record
		--	adresa sa koje se cita instrukcija iz instrukcijskog kesa
		inst_address : address_array_t;
		--	podatak za upis u kes podataka
		mem_data : word_t;
		--	adresa sa koje se cita/upisuje podatak u kesu podataka
		mem_address : address_t;
	end record cpu_out_data_t;
	
	-- CPU types end
	
	--	backend types
	
	type backend_in_data_t is record
		func_control : func_units_control_t;
		operand_values : jzp_out_data_array_t;
		--	podatak koji stize iz memorije podataka
		mem_data : word_t;
	end record backend_in_data_t;
	
	type backend_out_control_t is record
		mem_busy : std_logic;
		mem_load : std_logic;
		mem_done : std_logic;
		mem_reg : reg_address;
		jump : std_logic;
		--	citanje iz memorije podataka
		read : std_logic;
		-- upis u memoriju podataka
		write : std_logic;
	end record backend_out_control_t;
	
	type backend_out_data_t is record
		jump_address : address_t;
		from_wsu : write_data_array_t;
		--	podatak koji se upisuje u memoriju podataka
		mem_data : word_t;
		--	adresa na koju ce biti upisan podataka u memoriju podataka
		mem_address : address_t;
	end record backend_out_data_t;
	
	--	backend types end
	
	--	General Purpose functions
	function unsigned_add(data : std_logic_vector; increment : natural) return std_logic_vector;
	function bool2std_logic(bool : boolean) return std_logic;
	function std2bool(s : std_logic) return boolean;

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

	function bool2std_logic(bool : boolean) return std_logic is
	begin
		if bool then
			return '1';
		else
			return '0';
		end if;
	end function bool2std_logic;

	function std2bool(s : std_logic) return boolean is
		constant b : boolean := false;
	begin
		case s is
			when '0'    => return false;
			when '1'    => return true;
			when others => return b;
		end case;
	end std2bool;

end package body vlsi_pkg;
