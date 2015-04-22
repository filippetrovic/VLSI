LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                
use ieee.numeric_std.all;
use work.vlsi_pkg.all;
                 

ENTITY switch_vhd_tst IS
END switch_vhd_tst;

ARCHITECTURE gpr_arch OF switch_vhd_tst IS
-- constants           
                                      
-- signals                                                   

signal in_data : switch_in_data_t;
signal out_data : switch_out_data_t;

component switch
	port(data_out : out switch_out_data_t;
		 data_in  : in  switch_in_data_t);
end component switch;

BEGIN
	i1 : switch
	PORT MAP (
		data_out => out_data,
		data_in => in_data
	);

                                           
PROCESS
	function set_input (h_type: hazard_type; op1: mnemonic_t ; valid1: std_logic; op2: mnemonic_t; valid2: std_logic)
		return switch_in_data_t is
		
		variable ret : switch_in_data_t;
		
	begin
		ret.haz_type := h_type;
		ret.instructions(0).op := op1;
		ret.instructions(0).valid := valid1;
		
		ret.instructions(1).op := op2;
		ret.instructions(1).valid := valid2;
		
		return ret;
	end function set_input;
	
BEGIN
	
	in_data <= set_input(No_hazard, ADD_M, '1', SUB_M, '1');
	wait for 5 ns;
	
	in_data <= set_input(No_hazard, BEQ_M, '1', SADC_M, '1');
	wait for 5 ns;
	
	in_data <= set_input(No_hazard, ADD_M, '0', SUB_M, '0');
	wait for 5 ns;
	
	in_data <= set_input(No_hazard, STORE_M, '1', BAL_M, '1');
	wait for 5 ns;
	
	in_data <= set_input(A_type, ADD_M, '1', SUB_M, '1');
	wait for 5 ns;
	
	in_data <= set_input(B_type, ADD_M, '1', SUB_M, '1');
	wait for 5 ns;
	
	in_data <= set_input(C_type, ADD_M, '1', SUB_M, '1');
	wait for 5 ns;
	
	in_data <= set_input(A_type, BHI_M, '1', LOAD_M, '1');
	wait for 5 ns;
	
	in_data <= set_input(No_hazard, STOP_M, '1', ERROR_M, '1');
	wait for 5 ns;
	
WAIT;                                                        
END PROCESS;
                                      
END gpr_arch;
