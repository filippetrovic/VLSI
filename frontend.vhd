library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity frontend is
	port(
		clk         : in  std_logic;
		rst         : in  std_logic;

		control_in  : in  id_control_in_t;
		data_in     : in  if_data_in_t;
		control_out : out if_control_out_t;
		data_out    : out id_data_out_t;

		mem_address : out address_array_t
	);
end entity frontend;

architecture arch of frontend is
	component if_stage
		port(clk         : in  std_logic;
			 reset       : in  std_logic;
			 control_in  : in  if_control_in_t;
			 data_in     : in  if_data_in_t;
			 control_out : out if_control_out_t;
			 data_out    : out if_data_out_t);
	end component if_stage;

	component id_stage
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 data_in     : in  id_data_in_t;
			 data_out    : out id_data_out_t;
			 control_in  : in  id_control_in_t;
			 control_out : out id_control_out_t);
	end component id_stage;

	-- IF stage connections
	signal if_control_in  : if_control_in_t;
	signal if_data_out    : if_data_out_t;
	-- ID stage connections
	signal id_data_in     : id_data_in_t;
	signal id_control_out : id_control_out_t;

begin
	if_stage_inst : component if_stage
		port map(
			clk         => clk,
			reset       => rst,
			control_in  => if_control_in,
			data_in     => data_in,
			control_out => control_out,
			data_out    => if_data_out
		);

	id_stage_inst : component id_stage
		port map(
			clk         => clk,
			rst         => rst,
			data_in     => id_data_in,
			data_out    => data_out,
			control_in  => control_in,
			control_out => id_control_out
		);

	if_control_in.jump      <= control_in.jump;
	if_control_in.stall     <= id_control_out.stall;
	id_data_in.instructions <= if_data_out.instructions;
	mem_address             <= if_data_out.addresses;

end architecture arch;

