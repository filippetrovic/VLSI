library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;
use ieee.std_logic_textio.all;
use std.textio.all;
     

entity frontend_and_middle_vhd_tst is
end frontend_and_middle_vhd_tst;

architecture test_arch of frontend_and_middle_vhd_tst is
	-- constants           

	-- signals                                                   
	signal clk         : STD_LOGIC;
	signal reset       : STD_LOGIC;
	signal frontend_in_data     : if_data_in_t;
	signal frontend_out_data    : id_data_out_t;
	signal frontend_in_control  : id_control_in_t;
	signal frontend_out_control : if_control_out_t;
	signal frontend_mem_address : address_array_t;

	component frontend
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 in_data     : in  if_data_in_t;
			 in_control  : in  id_control_in_t;
			 mem_address : out address_array_t;
			 out_data    : out id_data_out_t;
			 out_control : out if_control_out_t);
	end component frontend;
	
	component middle
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 in_data     : in  id_data_out_t;
			 in_control  : in  middle_in_control_t;
			 out_data    : out middle_out_data_t;
			 out_control : out middle_out_control_t);
	end component middle;

	signal middle_in_data : id_data_out_t;	
	signal middle_in_control : middle_in_control_t;
	signal middle_out_data : middle_out_data_t;
	signal middle_out_control : middle_out_control_t;

	-- memorija
	type memory_t is array (0 to 2 ** 8) of word_t;
	signal memory : memory_t := (others => (others => 'U'));

	signal mem_init_done : bit;

begin
	i1 : frontend
		port map(clk         => clk,
			     rst         => reset,
			     in_data     => frontend_in_data,
			     in_control  => frontend_in_control,
			     mem_address => frontend_mem_address,
			     out_data    => frontend_out_data,
			     out_control => frontend_out_control
		);
	
	frontend_in_control.stall <= middle_out_control.stall;

	mid: component middle
		port map(
			clk         => clk,
			rst         => reset,
			in_data     => middle_in_data,
			in_control  => middle_in_control,
			out_data    => middle_out_data,
			out_control => middle_out_control
		);	
	
	middle_in_data.instructions <= frontend_out_data.instructions;
	
	
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
		frontend_in_control.jump  <= '0';
		
		middle_in_control.mem_busy <= '0';
		middle_in_control.mem_load <= '0';
		middle_in_control.mem_done <= '0';
		middle_in_control.mem_reg  <= (others => '-');
		
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
		wait until rising_edge(clk);
		
		middle_in_control.mem_busy <= '1';
		middle_in_control.mem_load <= '0';
		middle_in_control.mem_done <= '0';
		middle_in_control.mem_reg  <= "00010";
		
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		middle_in_control.mem_busy <= '0';
		middle_in_control.mem_load <= '0';
		middle_in_control.mem_done <= '1';
		middle_in_control.mem_reg  <= "-----";
		
		wait until rising_edge(clk);
		middle_in_control.mem_busy <= '1';
		middle_in_control.mem_load <= '1';
		middle_in_control.mem_done <= '0';
		middle_in_control.mem_reg  <= "00000";
		
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		
		middle_in_control.mem_busy <= '0';
		middle_in_control.mem_load <= '0';
		middle_in_control.mem_done <= '1';
		middle_in_control.mem_reg  <= "-----";
		
		wait until rising_edge(clk);
		middle_in_control.mem_done <= '0';
		
		wait;
	end process;

	-- simulacija memorije
	init : process is
		file f : text open read_mode is "front_and_middle_test_mem_in.txt";

		variable line_str : line;
		variable address  : address_t;
		variable data     : word_t;

		variable instructions : word_array_t;

	begin
		reset         <= '1';
		mem_init_done <= '0';

		readline(f, line_str);
		hread(line_str, address);
		frontend_in_data.init_pc <= address;

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

			if frontend_out_control.read = '1' then
				for i in word_array_t'range loop
					instructions(i) := memory(to_integer(unsigned(frontend_mem_address(i))));
				end loop;
				for i in word_array_t'range loop
					frontend_in_data.mem_values(i) <= instructions(i);
				end loop;
			end if;

		end loop;

	end process init;

end test_arch;
