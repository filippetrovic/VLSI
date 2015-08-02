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

ENTITY id_stage_vhd_tst IS
END id_stage_vhd_tst;

ARCHITECTURE id_stage_arch OF id_stage_vhd_tst IS
-- constants           
                                      
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
signal in_data : id_data_in_t;
signal out_data : id_data_out_t;
signal in_control : id_control_in_t;
signal out_control : id_control_out_t;

COMPONENT id_stage
	PORT (
		clk : in std_logic;
		rst : in std_logic;
		in_data: in id_data_in_t;
		out_data: out id_data_out_t;
		in_control: in id_control_in_t;
		out_control: out id_control_out_t
	);
END COMPONENT;
BEGIN
	i1 : id_stage
	PORT MAP (
-- list connections between master ports and signals
		clk => clk,
		rst => reset,
		in_data => in_data,
		out_data => out_data,
		in_control => in_control,
		out_control => out_control
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
  in_control.jump <= '0';
  in_control.stall <= '0';
	reset <= '1';
	wait until rising_edge(clk);
	reset <= '0';
	
	in_data.instructions(0).instruction <= "00000111111010100011000000000000";
  in_data.instructions(0).pc <= std_logic_vector(to_unsigned(0, 32));
  in_data.instructions(0).valid <= '1';	
	
	in_data.instructions(1).instruction <= "00011100000001111011000000000000";
  in_data.instructions(1).pc <= std_logic_vector(to_unsigned(1, 32));
  in_data.instructions(1).valid <= '1';

  wait until rising_edge(clk);

  in_control.stall <= '1';

  wait until rising_edge(clk);
  in_control.stall <= '0';
  in_control.jump <= '1';
  
 	in_data.instructions(0).instruction <= "00000101011011111100000000000000";
  in_data.instructions(0).pc <= std_logic_vector(to_unsigned(2, 32));
  in_data.instructions(0).valid <= '0';	
	
	in_data.instructions(1).instruction <= "00000011101110010101000000000000";
  in_data.instructions(1).pc <= std_logic_vector(to_unsigned(3, 32));
  in_data.instructions(1).valid <= '0';

	wait until rising_edge(clk);
	in_control.jump <= '0';
	
	in_data.instructions(0).instruction <= "00000111111010100011000000000000";
  in_data.instructions(0).pc <= std_logic_vector(to_unsigned(4, 32));
  in_data.instructions(0).valid <= '0';	
	
	in_data.instructions(1).instruction <= "00011100000001111011000000000000";
  in_data.instructions(1).pc <= std_logic_vector(to_unsigned(5, 32));
  in_data.instructions(1).valid <= '0';
  
  wait until rising_edge(clk);

 	in_data.instructions(0).instruction <= "00000101011011111100000000000000";
  in_data.instructions(0).pc <= std_logic_vector(to_unsigned(6, 32));
  in_data.instructions(0).valid <= '1';	
	
	in_data.instructions(1).instruction <= "00000011101110010101000000000000";
  in_data.instructions(1).pc <= std_logic_vector(to_unsigned(7, 32));
  in_data.instructions(1).valid <= '1';

WAIT;                                                        
END PROCESS;
                                      
END id_stage_arch;
