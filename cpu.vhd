library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity cpu is
	port(
		clk             : in  std_logic;
		rst             : in  std_logic;
		cpu_in_data     : in  cpu_in_data_t;
		cpu_out_data	: out cpu_out_data_t;
		cpu_out_control : out cpu_out_control_t
	);
end entity cpu;

architecture RTL of cpu is

	--	frontend signals
	signal front_in_control  : id_control_in_t;
	signal front_in_data     : if_data_in_t;
	signal front_out_control : if_control_out_t;
	signal front_out_data    : id_data_out_t;
	signal front_mem_address : address_array_t;
	
	--	middle signals
	signal middle_in_data     : middle_in_data_t;
	signal middle_in_control  : middle_in_control_t;
	signal middle_out_data    : middle_out_data_t;
	signal middle_out_control : middle_out_control_t;
begin
	front : entity work.frontend
		port map(
			clk         => clk,
			rst         => rst,
			in_control  => front_in_control,
			in_data     => front_in_data,
			out_control => front_out_control,
			out_data    => front_out_data,
			mem_address => front_mem_address
		);
	
	-- from frontend to cpu
	cpu_out_control.read_inst <= front_out_control.read;
	cpu_out_data.inst_address <= front_mem_address;
	
	-- from cpu to frontend
	front_in_data.init_pc <= cpu_in_data.init_pc;
	front_in_data.mem_values <= cpu_in_data.mem_values;
	
	middle_inst : entity work.middle
		port map(
			clk         => clk,
			rst         => rst,
			in_data     => middle_in_data,
			in_control  => middle_in_control,
			out_data    => middle_out_data,
			out_control => middle_out_control
		);
		
	--	from frontend to middle
	middle_in_data.from_id <= front_out_data;
	
	--	from middle to frontend
	front_in_control.stall <= middle_out_control.stall;
	
	-- from middle to cpu
	cpu_out_control.stop <= middle_out_control.stop;
	
end architecture RTL;

