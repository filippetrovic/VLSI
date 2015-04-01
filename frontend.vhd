library ieee;
use ieee.std_logic_1164.all;
use work.vlsi_pkg.all;

-- ovaj entitet predstavlja prednji kraj procesora, tj interfejs ka
-- instrukcijskoj kes memoriji, if fazu, id fazu, i interfejs ka sredisnjem
-- delu procesora koji je zaduzen za rasporedjivanje, kontrolu harazda i sl.
-- U frontendu nema dohvatanja operanada!
entity frontend is
	port (
		clk : in std_logic;
		rst : in std_logic;
		
		in_data: in if_data_in_t;
		in_control: in id_control_in_t;
		
		mem_address: out address_array_t;
		out_data: out id_data_out_t;
		out_control: out if_control_out_t
	);
end entity frontend;

architecture RTL of frontend is
	component id_stage
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 in_data     : in  id_data_in_t;
			 out_data    : out id_data_out_t;
			 in_control  : in  id_control_in_t;
			 out_control : out id_control_out_t);
	end component id_stage;
	component if_stage
		port(clk         : in  std_logic;
			 reset       : in  std_logic;
			 in_data     : in  if_data_in_t;
			 out_data    : out if_data_out_t;
			 in_control  : in  if_control_in_t;
			 out_control : out if_control_out_t);
	end component if_stage;
	
	signal if_out_data : if_data_out_t; 
	
	signal id_data_in : id_data_in_t;
	signal if_in_control : if_control_in_t;

	signal id_out_control : id_control_out_t;
	
begin
	if1 : if_stage
		port map(clk         => clk,
			     reset       => rst,
			     in_data     => in_data,
			     out_data    => if_out_data,
			     in_control  => if_in_control,
			     out_control => out_control);
	id : id_stage
		port map(clk         => clk,
			     rst         => rst,
			     in_data     => id_data_in,
			     out_data    => out_data,
			     in_control  => in_control,
			     out_control => id_out_control);
	id_data_in.instructions <= if_out_data.instructions;
	if_in_control.jump <= in_control.jump;
	if_in_control.stall <= id_out_control.stall;
	mem_address <= if_out_data.mem_address;
	
end architecture RTL;
