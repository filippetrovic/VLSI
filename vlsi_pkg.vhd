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
	
	type mnemonic_t is (
		AND_M, SUB_M, ADD_M, ADC_M, SBC_M, CMP_M, SSUB_M, SADD_M, SADC_M, SSBC_M,
		MOV_M, NOT_M, SL_M, SR_M, ASR_M,
--		MOV_M, -- u tekstu se dva puta pominje MOV instrukcija 
		SMOV_M,
		LOAD_M, STORE_M,
		BEQ_M, BGT_M, BHI_M, BAL_M, BLAL_M,
		STOP_M,
		ERROR_M
	);
--	TODO: Ovo izaziva neki critical warning: 
--	18061 Ignored Power-Up Level option on the following registers:
--	Critical Warning (18010): Register stage_buff_reg.instructions[1].op[3] will power up to High
--	Critical Warning (18010): Register stage_buff_reg.instructions[1].op[4] will power up to High
--	Critical Warning (18010): Register stage_buff_reg.instructions[0].op[3] will power up to High
--	Critical Warning (18010): Register stage_buff_reg.instructions[0].op[4] will power up to High
	attribute enum_encoding : string;
	attribute enum_encoding of mnemonic_t : type is "sequential";

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
