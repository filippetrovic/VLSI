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

ENTITY if_stage_vhd_tst IS
END if_stage_vhd_tst;

ARCHITECTURE if_stage_arch OF if_stage_vhd_tst IS
-- constants           
                                      
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
signal in_data : if_data_in_t;
signal out_data : if_data_out_t;
signal in_control : if_control_in_t;
signal out_control : if_control_out_t;

COMPONENT if_stage
	PORT (
		clk : in std_logic;
		reset: in std_logic;
		in_data: in if_data_in_t;
		out_data: out if_data_out_t;
		in_control: in if_control_in_t;
		out_control: out if_control_out_t
	);
END COMPONENT;
BEGIN
	i1 : if_stage
	PORT MAP (
-- list connections between master ports and signals
		clk => clk,
		reset => reset,
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
	
	wait until rising_edge(clk);
	wait until rising_edge(clk);
	wait until rising_edge(clk);
	wait until rising_edge(clk);
	
	in_control.stall <= '1';
	wait until rising_edge(clk);
	in_control.stall <= '0';
	
	in_control.jump <= '1';

	
	in_data.jump_address <= (7 => '1', others => '0');
	wait until rising_edge(clk);
	in_control.jump <= '0';
  in_data.jump_address <= (others => '0');
	
	
	
WAIT;                                                        
END PROCESS;

process (clk, out_control)
  variable next1, next2 : std_logic_vector(31 downto 0);
begin
    if (rising_edge(clk)) then
      if (out_control.read = '1') then
        next1 := out_data.mem_address(0);
        next2 := out_data.mem_address(1);
      end if;
      
      in_data.mem_values(0) <= next1;
      in_data.mem_values(1) <= next2;
    
    end if;
end process;  
                                      
END if_stage_arch;
