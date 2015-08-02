LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

ENTITY jzp_vhd_tst IS
END jzp_vhd_tst;

ARCHITECTURE jzp_test OF jzp_vhd_tst IS
	-- constants           

	-- signals                                                   

	signal i_data : jzp_in_data_t;
	signal o_data : jzp_out_data_t;

	component jzp
		port(in_data  : in jzp_in_data_t;
			 out_data : out  jzp_out_data_t);
	end component jzp;

BEGIN
	i1 : jzp
		PORT MAP(
			in_data  => i_data,
			out_data => o_data
		);

	PROCESS

	BEGIN
		
		i_data.from_wsu(0).value <= std_logic_vector(to_unsigned(1, 32));
		i_data.from_wsu(0).write <= '1';
		i_data.from_wsu(0).address <= std_logic_vector(to_unsigned(1, 5));
		
		i_data.from_wsu(1).value <= std_logic_vector(to_unsigned(2, 32));
		i_data.from_wsu(1).write <= '1';
		i_data.from_wsu(1).address <= std_logic_vector(to_unsigned(2, 5));
		
		i_data.from_wsu(2).value <= std_logic_vector(to_unsigned(3, 32));
		i_data.from_wsu(2).write <= '1';
		i_data.from_wsu(2).address <= std_logic_vector(to_unsigned(3, 5));
		
		i_data.from_wsu(3).value <= std_logic_vector(to_unsigned(4, 32));
		i_data.from_wsu(3).write <= '1';
		i_data.from_wsu(3).address <= std_logic_vector(to_unsigned(4, 5));
		
		i_data.address <= std_logic_vector(to_unsigned(5, 5));
		i_data.from_gpr <= std_logic_vector(to_unsigned(10, 32));
		
		wait for 5 ns;
		
		i_data.address <= std_logic_vector(to_unsigned(1, 5));
		i_data.from_gpr <= std_logic_vector(to_unsigned(10, 32));
		
		wait for 5 ns;
		
		i_data.address <= std_logic_vector(to_unsigned(8, 5));
		i_data.from_gpr <= std_logic_vector(to_unsigned(10, 32));
		
		wait for 5 ns;
		
		i_data.address <= std_logic_vector(to_unsigned(2, 5));
		i_data.from_gpr <= std_logic_vector(to_unsigned(10, 32));
		
		wait for 5 ns;
		
		i_data.address <= std_logic_vector(to_unsigned(3, 5));
		i_data.from_gpr <= std_logic_vector(to_unsigned(10, 32));
		
		
		WAIT;
	END PROCESS;

END jzp_test;
