library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity middle is
	port (
		clk : in std_logic;
		rst : in std_logic;
		in_data : in id_data_out_t;
		in_control : in middle_in_control_t;
		out_data : out middle_out_data_t;
		out_control : out middle_out_control_t
	);
end entity middle;

architecture RTL of middle is
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
	
	component switch
		port(data_in    : in  switch_in_data_t;
			 control_in : in  switch_in_control_t;
			 data_out   : out switch_out_data_t);
	end component switch;
	
	signal switch_in_data : switch_in_data_t;
	signal switch_in_control : switch_in_control_t;
	signal switch_out_data : switch_out_data_t;
begin
	
	haz_d: component hazard_detector
		port map(
			in_data     => haz_in_data,
			in_control  => haz_in_control,
			out_control => haz_out_control
		);
	
	haz_in_data.instructions <= in_data.instructions;	
	haz_in_control.inst_ready <= stall_out_control.inst_ready;
	haz_in_control.mem_busy <= in_control.mem_busy;
	haz_in_control.mem_load <= in_control.mem_load;
	haz_in_control.mem_reg <= in_control.mem_reg;
	
	stall_g: component stall_generator
		port map(
			clk         => clk,
			rst         => rst,
			in_control  => stall_in_control,
			out_control => stall_out_control
		);
	
	stall_in_control.haz_type <= haz_out_control.haz_type;
	stall_in_control.mem_done <= in_control.mem_done;
	out_control.stall <= stall_out_control.stall;
	
	sw : component switch
		port map(
			data_in    => switch_in_data,
			control_in => switch_in_control,
			data_out   => switch_out_data
		);
	
	switch_in_data.instructions <= in_data.instructions;
	switch_in_control.inst_go <= stall_out_control.inst_go;
	out_data.func_control <= switch_out_data.func_control;

end architecture RTL;
