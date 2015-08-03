library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity frontend_test is
end entity frontend_test;

architecture test_arch of frontend_test is
	signal clk : std_logic;
	signal rst : std_logic;

	component frontend
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 in_control  : in  id_control_in_t;
			 in_data     : in  if_data_in_t;
			 out_control : out if_control_out_t;
			 out_data    : out id_data_out_t;
			 mem_address : out address_array_t);
	end component frontend;

	type memory_t is array (0 to 2 ** 8) of word_t;

	signal memory : memory_t := (others => (others => 'U'));

	signal mem_init_done : bit;

	-- Frontend connections
	signal control_in  : id_control_in_t;
	signal data_in     : if_data_in_t;
	signal control_out : if_control_out_t;
	signal data_out    : id_data_out_t;
	signal mem_address : address_array_t;

begin
	
	frontend_inst : component frontend
		port map(
			clk         => clk,
			rst         => rst,
			in_control  => control_in,
			in_data     => data_in,
			out_control => control_out,
			out_data    => data_out,
			mem_address => mem_address
		);

	init : process is
		file f : text open read_mode is "memory.txt";

		variable line_str : line;
		variable address  : address_t;
		variable data     : word_t;

		variable instructions : word_array_t;

	begin
		mem_init_done <= '0';

		rst <= '1';

		readline(f, line_str);
		hread(line_str, address);

		data_in.init_pc <= address;

		while not endfile(f) loop
			readline(f, line_str);
			hread(line_str, address);
			read(line_str, data);

			memory(to_integer(unsigned(address))) <= data;

		end loop;

		wait for CLK_PERIOD;

		rst <= '0';

		mem_init_done <= '1';

		loop
			wait until rising_edge(clk);

			if control_out.read = '1' then
				for i in word_array_t'range loop
					instructions(i) := memory(to_integer(unsigned(mem_address(i))));
				end loop;
				for i in word_array_t'range loop
					data_in.mem_values(i) <= instructions(i);
				end loop;
			end if;

		end loop;

	end process init;

	clock_driver : process
		constant period : time := CLK_PERIOD;
	begin
		clk <= '0';
		wait for period / 2;
		clk <= '1';
		wait for period / 2;
	end process clock_driver;

	stim_proc : process is
	begin
		control_in.jump  <= '0';
		control_in.stall <= '0';

		wait until mem_init_done = '1';

		wait until rising_edge(clk);

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		control_in.stall <= '1';

		wait until rising_edge(clk);

		control_in.stall <= '0';

		wait until rising_edge(clk);

		control_in.jump      <= '1';
		data_in.jump_address <= X"0000_0017";

		wait until rising_edge(clk);

		control_in.jump <= '0';

		wait until rising_edge(clk);
		wait until rising_edge(clk);

		control_in.stall <= '1';

		wait until rising_edge(clk);

		control_in.stall <= '0';

		control_in.jump      <= '1';
		data_in.jump_address <= X"0000_0012";

		wait until rising_edge(clk);

		control_in.jump <= '0';

		wait;
	end process stim_proc;

end architecture test_arch;

