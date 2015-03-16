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
		valid: std_logic;
	end record if_control_out_t;
	
--	if stage types end
	
	
	
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
