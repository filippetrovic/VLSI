LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

ENTITY psw_vhd_tst IS
END psw_vhd_tst;

ARCHITECTURE psw_test OF psw_vhd_tst IS
	-- constants           

	-- signals                                                   

	signal clock : std_logic;
	signal reset : std_logic;
	signal in_data : psw_synch_in_data_array_t;
	signal out_data : psw_register_t;
	
	component psw
		port(clk      : in  std_logic;
			 rst      : in  std_logic;
			 in_data  : in  psw_synch_in_data_array_t;
			 out_data : out psw_register_t);
	end component psw;

BEGIN
	i1 : psw
		port map(
			clk      => clock,
			rst      => reset,
			in_data  => in_data,
			out_data => out_data
		);

-- clock
	PROCESS                                               
		variable clk_next : std_logic := '1';                                    
	BEGIN                                                        
		loop
			clock <= clk_next;
			clk_next := not clk_next;
			wait for 5 ns;
		end loop;                                                      
	END PROCESS;


	PROCESS
		function setPswFlags(n : std_logic; z : std_logic; c : std_logic; v : std_logic) 
		return psw_register_t is
		
			variable toRet : psw_register_t;
		begin
			
			toRet := (
				N_POSITION => n,
				Z_POSITION => z,
				C_POSITION => c,
				V_POSITION => v,
				others => '0'
			);
			
			return toRet;
		end function setPswFlags;
		
	BEGIN
		reset <= '1';
		wait until rising_edge(clock);
		reset <= '0';
		
		in_data(0).psw_value <= setPswFlags('1','1','0','0');
		in_data(0).update_psw <= '1';
		in_data(1).psw_value <= setPswFlags('0','0','1','1');
		in_data(1).update_psw <= '1';
		wait until rising_edge(clock);
		
		in_data(0).psw_value <= setPswFlags('1','0','0','0');
		in_data(0).update_psw <= '0';
		in_data(1).psw_value <= setPswFlags('0','0','0','1');
		in_data(1).update_psw <= '1';
		wait until rising_edge(clock);
		
		in_data(0).psw_value <= setPswFlags('1','1','1','0');
		in_data(0).update_psw <= '1';
		in_data(1).psw_value <= setPswFlags('0','1','1','1');
		in_data(1).update_psw <= '0';
		wait until rising_edge(clock);
		
		in_data(0).psw_value <= setPswFlags('0','1','0','0');
		in_data(0).update_psw <= '0';
		in_data(1).psw_value <= setPswFlags('0','0','1','0');
		in_data(1).update_psw <= '0';
		wait until rising_edge(clock);
		
		in_data(0).psw_value <= setPswFlags('0','0','0','0');
		in_data(0).update_psw <= '1';
		in_data(1).psw_value <= setPswFlags('1','1','1','1');
		in_data(1).update_psw <= '1';
		reset <= '1';
		wait until rising_edge(clock);
		reset <= '0';
		
		in_data(0).psw_value <= setPswFlags('0','1','0','0');
		in_data(0).update_psw <= '0';
		in_data(1).psw_value <= setPswFlags('0','0','1','0');
		in_data(1).update_psw <= '0';
		wait until rising_edge(clock);
		
		in_data(0).psw_value <= setPswFlags('1','0','0','0');
		in_data(0).update_psw <= '0';
		in_data(1).psw_value <= setPswFlags('0','0','0','1');
		in_data(1).update_psw <= '1';
		wait until rising_edge(clock);
		
		WAIT;
	END PROCESS;

END psw_test;
