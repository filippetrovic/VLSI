library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package vlsi_pkg is 
	constant ISSUE_WIDTH : integer := 2;
	
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
	
	function unsigned_add(data : std_logic_vector; increment : natural) return std_logic_vector;
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
end package body vlsi_pkg;
