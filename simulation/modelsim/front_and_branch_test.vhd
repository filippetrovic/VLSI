library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity front_and_branch_test is
end entity front_and_branch_test;

architecture test_arch of front_and_branch_test is
	component frontend
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 control_in  : in  id_control_in_t;
			 data_in     : in  if_data_in_t;
			 control_out : out if_control_out_t;
			 data_out    : out id_data_out_t;
			 mem_address : out address_array_t);
	end component frontend;

	component branch_unit
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 control_in  : in  branch_unit_control_in_t;
			 data_in     : in  branch_unit_data_in_t;
			 data_out    : out branch_unit_data_out_t;
			 control_out : out branch_unit_control_out_t);
	end component branch_unit;

	signal clk : std_logic;
	signal rst : std_logic;

	type memory_t is array (0 to 2 ** 8) of word_t;

	signal memory : memory_t := (others => (others => 'U'));

	signal mem_init_done : bit;

	signal fe_control_in  : id_control_in_t;
	signal fe_data_in     : if_data_in_t;
	signal fe_control_out : if_control_out_t;
	signal fe_data_out    : id_data_out_t;
	signal fe_mem_address : address_array_t;

	signal br_data_in     : branch_unit_data_in_t;
	signal br_data_out    : branch_unit_data_out_t;
	signal br_control_out : branch_unit_control_out_t;
	signal br_control_in  : branch_unit_control_in_t;

begin
	dut_1 : component frontend
		port map(
			clk         => clk,
			rst         => rst,
			control_in  => fe_control_in,
			data_in     => fe_data_in,
			control_out => fe_control_out,
			data_out    => fe_data_out,
			mem_address => fe_mem_address
		);

	dut_2 : component branch_unit
		port map(
			clk         => clk,
			rst         => rst,
			control_in  => br_control_in,
			data_in     => br_data_in,
			data_out    => br_data_out,
			control_out => br_control_out
		);

	fe_control_in.jump      <= br_control_out.jump;
	fe_data_in.jump_address <= br_data_out.jump_address;
	br_data_in.instruction  <= fe_data_out.instructions(0);

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
		fe_data_in.init_pc <= address;

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

			if fe_control_out.read = '1' then
				for i in word_array_t'range loop
					instructions(i) := memory(to_integer(unsigned(fe_mem_address(i))));
				end loop;
				for i in word_array_t'range loop
					fe_data_in.mem_values(i) <= instructions(i);
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
		
		fe_control_in.stall  <= '0';
		br_control_in.go <= '1';

		wait until mem_init_done = '1';

		wait until rising_edge(clk);

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		fe_control_in.stall <= '1';

		wait until rising_edge(clk);

		fe_control_in.stall <= '0';

		-- sledeca instrukcija je BHI pa postavljamo PSW tako da
		-- je uslov skoka ispunjen
		br_data_in.psw <= (29 => '1', others => '0');

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		fe_control_in.stall <= '1';

		wait until rising_edge(clk);

		fe_control_in.stall <= '0';

		wait;
	end process stim_proc;

end architecture test_arch;

