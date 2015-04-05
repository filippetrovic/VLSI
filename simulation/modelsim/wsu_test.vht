LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

--PACKAGE if_stage_data_type IS 
--TYPE in_data_mem_values_31_0_type IS ARRAY (31 DOWNTO 0) OF STD_LOGIC;
--TYPE in_data_mem_values_31_0_0_1_type IS ARRAY (0 TO 1) OF in_data_mem_values_31_0_type;
--SUBTYPE in_data_mem_values_type IS in_data_mem_values_31_0_0_1_type;
--TYPE out_data_mem_address_31_0_type IS ARRAY (31 DOWNTO 0) OF STD_LOGIC;
--TYPE out_data_mem_address_31_0_0_1_type IS ARRAY (0 TO 1) OF out_data_mem_address_31_0_type;
--SUBTYPE out_data_mem_address_type IS out_data_mem_address_31_0_0_1_type;
--END if_stage_data_type;                  

ENTITY write_sinh_unit_vhd_tst IS
END write_sinh_unit_vhd_tst;

ARCHITECTURE gpr_arch OF write_sinh_unit_vhd_tst IS
-- constants           
                                      
-- signals                                                   

signal in_data : wsh_in_data_array_t;
signal out_data : write_data_array_t;

component write_sinh_unit
	port(out_data : out write_data_array_t;
		 in_data  : in  wsh_in_data_array_t);
end component write_sinh_unit;

BEGIN
	i1 : write_sinh_unit
	PORT MAP (
		out_data => out_data,
		in_data => in_data
	);

                                           
PROCESS
	
BEGIN
	wait for 5 ns;
	in_data(0).pc <= "00000000000000000000000000000011";
	in_data(0).address <= "00001";
	in_data(0).valid <= '1';
	in_data(0).value <= "00000000000000000000000000000011";
	
 	in_data(1).pc <= "00000000000000000000000000000000";
	in_data(1).address <= "00001";
	in_data(1).valid <= '1';
	in_data(1).value <= "00000000000000000000000000000000";
	
	in_data(2).pc <= "00000000000000000000000000000010";
	in_data(2).address <= "00001";
	in_data(2).valid <= '1';
	in_data(2).value <= "00000000000000000000000000000010";
	
	in_data(3).pc <= "00000000000000000000000000000001";
	in_data(3).address <= "00001";
	in_data(3).valid <= '1';
	in_data(3).value <= "00000000000000000000000000000001";
WAIT;                                                        
END PROCESS;
                                      
END gpr_arch;
