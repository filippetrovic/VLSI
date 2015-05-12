LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

ENTITY stall_generator_vhd_tst IS
END stall_generator_vhd_tst;

ARCHITECTURE stall_generator_test OF stall_generator_vhd_tst IS
	-- constants           

	-- signals                                                   

	signal in_ctrl : stall_generator_in_control_t;
	signal out_ctrl : stall_generator_out_control_t;
	signal reset : std_logic;
	signal clock : std_logic;
	
	component stall_generator
		port(clk: in std_logic;
			 rst: in std_logic;
			 in_control : in stall_generator_in_control_t;
			 out_control : out  stall_generator_out_control_t);
	end component stall_generator;

BEGIN
	i1 : stall_generator
		PORT MAP(
			clk => clock,
			rst => reset,
			in_control  => in_ctrl,
			out_control => out_ctrl
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

	BEGIN
		in_ctrl.haz_type <= No_hazard;		
		in_ctrl.mem_done <= '0';
		reset <= '1';
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		reset <= '0';
		
		wait until rising_edge(clock);
		wait for 1 ns;
		in_ctrl.haz_type <= A_type;
		wait until rising_edge(clock);
		wait for 1 ns;
		in_ctrl.haz_type <= No_hazard;		
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		
		in_ctrl.haz_type <= B_type;
		wait until rising_edge(clock);
		in_ctrl.haz_type <= No_hazard;
		wait until rising_edge(clock);
		wait until rising_edge(clock);
		wait until rising_edge(clock);								
		in_ctrl.mem_done <= '1';		
		wait until rising_edge(clock);								
		in_ctrl.mem_done <= '0';
    wait until rising_edge(clock);														
		
		WAIT;
	END PROCESS;

END stall_generator_test;
