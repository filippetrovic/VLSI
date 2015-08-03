library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity test_if_stage is
end entity test_if_stage;

architecture test_arch of test_if_stage is

	component if_stage
		port(clk         : in  std_logic;
			 reset       : in  std_logic;
			 control_in  : in  if_control_in_t;
			 data_in     : in  if_data_in_t;
			 control_out : out if_control_out_t;
			 data_out    : out if_data_out_t);
	end component if_stage;


	type memory_t is array (0 to 2 ** 8) of word_t;

	signal memory   : memory_t   := (others => (others => 'U'));
	
	signal clk : std_logic;
	signal reset : std_logic;
	signal control_in : if_control_in_t;
	signal data_in : if_data_in_t;
	signal control_out : if_control_out_t;
	signal data_out : if_data_out_t;

	signal mem_init_done : bit;

begin
	init : process is
		file f : text open read_mode is "memory.txt";

		variable line_str : line;
		variable address  : address_t;
		variable data     : word_t;

		variable instructions : word_array_t;

	begin
		
		mem_init_done <= '0';
		
		reset <= '1';

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

		reset <= '0';

		mem_init_done <= '1';

		loop
			wait until rising_edge(clk);
			
			if control_out.read = '1' then
				for i in word_array_t'range loop
					instructions(i) := memory(to_integer(unsigned(data_out.addresses(i))));
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

	dut : component if_stage
		port map(
			clk         => clk,
			reset       => reset,
			control_in  => control_in,
			data_in     => data_in,
			control_out => control_out,
			data_out    => data_out
		);

	stim_proc : process is
	begin
		
		control_in.jump <= '0';
		control_in.stall <= '0';

		wait until mem_init_done = '1';

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		control_in.stall <= '1';
		
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		control_in.stall <= '0';
		
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		control_in.jump <= '1';
		data_in.jump_address <= X"0000_0012";
		
		wait until rising_edge(clk);
		
		control_in.jump <= '0';
		
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		control_in.jump <= '1';
		data_in.jump_address <= X"0000_0010";
		
		wait until rising_edge(clk);
		
		control_in.jump <= '0';						

		wait;

	end process stim_proc;

end architecture test_arch;

