library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

--	PSW entitet koji je deo Backenda procesora.
--	Sadrzi psw_registar i psw_synch.
entity psw is
	port (
		clk : in std_logic;
		rst : in std_logic;
		in_data: in psw_synch_in_data_array_t;
		out_data: out psw_register_t
	);
end entity psw;

architecture RTL of psw is
	component psw_synch
		port(in_data  : in  psw_synch_in_data_array_t;
			 out_data : out psw_register_t;
			 write    : out std_logic);
	end component psw_synch;
	
	component psw_register
		port(clk       : in  std_logic;
			 rst       : in  std_logic;
			 write     : in  std_logic;
			 in_value  : in  psw_register_t;
			 out_value : out psw_register_t);
	end component psw_register;
	
	signal write_connector : std_logic;
	signal data_connector : psw_register_t;
begin
	psw_s : psw_synch
		port map(
			in_data  => in_data,
			out_data => data_connector,
			write    => write_connector
		);
	psw_r : psw_register
		port map(
			clk       => clk,
			rst       => rst,
			write     => write_connector,
			in_value  => data_connector,
			out_value => out_data
		);
end architecture RTL;
