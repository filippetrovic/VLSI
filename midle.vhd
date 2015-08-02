library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity midle is
	port (
		clk : in std_logic;
		rst : in std_logic;
		midle_in_data : in id_data_out_t;
		midle_out_stall : out std_logic;
		midle_mem_busy : in std_logic;
		midle_mem_load : in std_logic;
		midle_mem_done : in std_logic;
		midle_mem_reg : in reg_address
	);
end entity midle;

architecture RTL of midle is
	component hazard_detector
		port(in_data     : in  haz_detector_in_data_t;
			 in_control  : in  haz_detector_in_control_t;
			 out_control : out haz_detector_out_control_t);
	end component hazard_detector;
	
	signal haz_in_data : haz_detector_in_data_t;
	signal haz_in_control : haz_detector_in_control_t;
	signal haz_out_control : haz_detector_out_control_t;
	
	component stall_generator
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 in_control  : in  stall_generator_in_control_t;
			 out_control : out stall_generator_out_control_t);
	end component stall_generator;
	
	signal stall_in_control : stall_generator_in_control_t;
	signal stall_out_control : stall_generator_out_control_t;
	
begin
	
	haz_d: component hazard_detector
		port map(
			in_data     => haz_in_data,
			in_control  => haz_in_control,
			out_control => haz_out_control
		);
	
	haz_in_data.instructions <= midle_in_data.instructions;	
	haz_in_control.inst_ready <= stall_out_control.inst_ready;
	haz_in_control.mem_busy <= midle_mem_busy;
	haz_in_control.mem_load <= midle_mem_load;
	haz_in_control.mem_reg <= midle_mem_reg;
	
	stall_g: component stall_generator
		port map(
			clk         => clk,
			rst         => rst,
			in_control  => stall_in_control,
			out_control => stall_out_control
		);
	
	stall_in_control.haz_type <= haz_out_control.haz_type;
	stall_in_control.mem_done <= midle_mem_done;
	midle_out_stall <= stall_out_control.stall;
	
end architecture RTL;
