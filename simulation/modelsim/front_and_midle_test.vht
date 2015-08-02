library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;
use ieee.std_logic_textio.all;
use std.textio.all;
     

entity frontend_and_midle_vhd_tst is
end frontend_and_midle_vhd_tst;

architecture test_arch of frontend_and_midle_vhd_tst is
	-- constants           

	-- signals                                                   
	signal clk         : STD_LOGIC;
	signal reset       : STD_LOGIC;
	signal in_data     : if_data_in_t;
	signal out_data    : id_data_out_t;
	signal in_control  : id_control_in_t;
	signal out_control : if_control_out_t;
	signal mem_address : address_array_t;

	component frontend
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 in_data     : in  if_data_in_t;
			 in_control  : in  id_control_in_t;
			 mem_address : out address_array_t;
			 out_data    : out id_data_out_t;
			 out_control : out if_control_out_t);
	end component frontend;
	
	component midle
		port(clk             : in  std_logic;
			 rst             : in  std_logic;
			 midle_in_data   : in  id_data_out_t;
			 midle_out_stall : out std_logic;
			 midle_mem_busy  : in  std_logic;
			 midle_mem_load  : in  std_logic;
			 midle_mem_done  : in  std_logic;
			 midle_mem_reg   : in  reg_address);
	end component midle;

	signal mid_in_data : id_data_out_t;
	signal mid_out_stall : std_logic;
	signal mid_mem_busy : std_logic;
	signal mid_mem_load : std_logic;
	signal mid_mem_done : std_logic;
	signal mid_mem_reg : reg_address;
	

	-- memorija
	type memory_t is array (0 to 2 ** 8) of word_t;
	signal memory : memory_t := (others => (others => 'U'));

	signal mem_init_done : bit;

begin
	i1 : frontend
		port map(clk         => clk,
			     rst         => reset,
			     in_data     => in_data,
			     in_control  => in_control,
			     mem_address => mem_address,
			     out_data    => out_data,
			     out_control => out_control
		);
	
	in_control.stall <= mid_out_stall;

	mid: component midle
		port map(
			clk             => clk,
			rst             => reset,
			midle_in_data   => mid_in_data,
			midle_out_stall => mid_out_stall,
			midle_mem_busy  => mid_mem_busy,
			midle_mem_load  => mid_mem_load,
			midle_mem_done  => mid_mem_done,
			midle_mem_reg   => mid_mem_reg
		);
		
	mid_in_data.instructions <= out_data.instructions;	
	
	
	
	
	-- clock
	process
		variable clk_next : std_logic := '1';
	begin
		loop
			clk      <= clk_next;
			clk_next := not clk_next;
			wait for 5 ns;
		end loop;
	end process;

	-- test
	process
	begin
		in_control.jump  <= '0';

		reset <= '1';
		wait until rising_edge(clk);
		reset <= '0';

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		wait;
	end process;

	-- simulacija memorije
	init : process is
		file f : text open read_mode is "mem_in.txt";

		variable line_str : line;
		variable address  : address_t;
		variable data     : word_t;

		variable instructions : word_array_t;

	begin
		reset         <= '1';
		mem_init_done <= '0';

		readline(f, line_str);
		hread(line_str, address);
		in_data.init_pc <= address;

		while not endfile(f) loop
			readline(f, line_str);
			hread(line_str, address);
			read(line_str, data);

			memory(to_integer(unsigned(address))) <= data;

		end loop;

		wait until rising_edge(clk);

		reset         <= '0';
		mem_init_done <= '1';

		loop
			wait until rising_edge(clk);

			if out_control.read = '1' then
				for i in word_array_t'range loop
					instructions(i) := memory(to_integer(unsigned(mem_address(i))));
				end loop;
				for i in word_array_t'range loop
					in_data.mem_values(i) <= instructions(i);
				end loop;
			end if;

		end loop;

	end process init;

end test_arch;
