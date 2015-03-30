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

ENTITY frontend_vhd_tst IS
END frontend_vhd_tst;

ARCHITECTURE frontend_arch OF frontend_vhd_tst IS
-- constants           
                                      
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
signal in_data : if_data_in_t;
signal out_data : id_data_out_t;
signal in_control : id_control_in_t;
signal out_control : if_control_out_t;
signal mem_address : address_array_t;

COMPONENT frontend
	port(clk         : in  std_logic;
		 rst         : in  std_logic;
		 in_data     : in  if_data_in_t;
		 in_control  : in  id_control_in_t;
		 mem_address : out address_array_t;
		 out_data    : out id_data_out_t;
		 out_control : out if_control_out_t);
end component frontend;
	
BEGIN
	i1 : frontend
	port map(clk         => clk,
		     rst         => reset,
		     in_data     => in_data,
		     in_control  => in_control,
		     mem_address => mem_address,
		     out_data    => out_data,
		     out_control => out_control);

-- clock
PROCESS                                               
	variable clk_next : std_logic := '1';                                    
BEGIN                                                        
	loop
		clk <= clk_next;
		clk_next := not clk_next;
		wait for 5 ns;
	end loop;                                                      
END PROCESS;

-- test
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
	wait until rising_edge(clk);
	
	in_control.jump <= '1';
	in_data.jump_address <= "11110000111100001111000011110000";
	wait until rising_edge(clk);
	in_data.jump_address <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
	in_control.jump <= '0';
		
	WAIT;                                                        
END PROCESS;

-- memorija
process (clk)
	variable next1, next2 : std_logic_vector(31 downto 0);
begin
	if (rising_edge(clk)) then
		if (out_control.read = '1') then
		next1 := mem_address(0);
		next2 := mem_address(1);
	end if;
      
	in_data.mem_values(0) <= next1;
	in_data.mem_values(1) <= next2;
    
	end if;
end process; 
                                   
END frontend_arch;
