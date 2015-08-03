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

ENTITY gpr_vhd_tst IS
END gpr_vhd_tst;

ARCHITECTURE gpr_arch OF gpr_vhd_tst IS
-- constants           
                                      
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL reset : STD_LOGIC;

signal in_data : gpr_in_data_t;
signal out_data : gpr_out_data_t;

component gpr_file
	port(clk      : in  std_logic;
		 rst      : in  std_logic;
		 in_data  : in  gpr_in_data_t;
		 out_data : out gpr_out_data_t);
end component gpr_file;

BEGIN
	i1 : gpr_file
	PORT MAP (
-- list connections between master ports and signals
		clk => clk,
		rst => reset,
		in_data => in_data,
		out_data => out_data
	);

PROCESS                                               
	variable clk_next : std_logic := '1';                                    
BEGIN                                                        
	loop
		clk <= clk_next;
		clk_next := not clk_next;
		wait for 5 ns;
	end loop;                                                      
END PROCESS;
                                           
PROCESS
	
BEGIN
  reset <= '1';
  wait until rising_edge(clk);
  reset <= '0';
  
  in_data.write_data_arr(0).address <= "00001";
  in_data.write_data_arr(0).value <= "10101010110111110000111001010101";
  in_data.write_data_arr(0).write <= '1';
  
  wait until rising_edge(clk);
  in_data.write_data_arr(0).address <= "00001";
  in_data.write_data_arr(0).value <= "11111111111111111111111111111111";
  in_data.write_data_arr(0).write <= '1';
  wait for 2 ns;
  in_data.read_address(1) <= "00001";
  wait until rising_edge(clk);
  
WAIT;                                                        
END PROCESS;
                                      
END gpr_arch;
