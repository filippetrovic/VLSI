library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity mem_unit_test is
end entity mem_unit_test;

architecture test_arch of mem_unit_test is
	component mem_unit
		port(clk         : in  std_logic;
			 rst         : in  std_logic;
			 in_control  : in  mem_unit_control_in_t;
			 in_data     : in  mem_unit_data_in_t;
			 out_control : out mem_unit_control_out_t;
			 out_data    : out mem_unit_data_out_t);
	end component mem_unit;
	signal clk         : std_logic;
	signal rst         : std_logic;
	signal in_control  : mem_unit_control_in_t;
	signal in_data     : mem_unit_data_in_t;
	signal out_control : mem_unit_control_out_t;
	signal out_data    : mem_unit_data_out_t;

	signal read, write  : std_logic;
	signal mem_data_out : word_t;
	signal mem_data_in  : word_t;
	signal mem_address  : address_t;

	type memory_t is array (0 to 2 ** 8) of word_t;

	signal memory : memory_t := (others => (others => '0'));

begin

	-- clock driver process
	clock_driver : process
		constant period : time := CLK_PERIOD;
	begin
		clk <= '0';
		wait for period / 2;
		clk <= '1';
		wait for period / 2;
	end process clock_driver;

	dut : component mem_unit
		port map(
			clk         => clk,
			rst         => rst,
			in_control  => in_control,
			in_data     => in_data,
			out_control => out_control,
			out_data    => out_data
		);

	-- kontrolni signali ka memoriji
	read         <= out_control.rd;
	write        <= out_control.wr;
	-- adresiranje memorije
	mem_address  <= out_data.address;
	-- linije podataka od memorije ka jedinici
	in_data.data <= mem_data_out;
	mem_data_in  <= out_data.data;

	memory_simulation : process is
		variable address : address_t;
		variable data    : word_t;
		variable ln      : line;

		file output_file : text is out "output.txt";
	begin
		loop
		
			wait until rising_edge(clk);
			
			if read = '1' then

				-- posto nemamo simuliranu memoriju ovde onda vracamo adresu
				-- sa koje treba da procitamo podatak
				address := mem_address;
				wait until rising_edge(clk); -- vreme
				wait until rising_edge(clk); -- odziva
				wait until rising_edge(clk); -- memorije
				
				mem_data_out <= memory(to_integer(unsigned(address)));

			elsif write = '1' then
				data    := mem_data_in;
				address := mem_address;

				report str(address) & " : " & str(data);

				wait until rising_edge(clk); -- vreme
				wait until rising_edge(clk); -- odziva
				wait until rising_edge(clk); -- memorije

				memory(to_integer(unsigned(address))) <= data;

				-- upis u fajl
				for i in memory'range loop
					std.textio.write(ln, hstr(std_logic_vector(to_unsigned(i, 32))));
					std.textio.write(ln, string'(" "));
					if i /= to_integer(unsigned(address)) then
						std.textio.write(ln, str(memory(i)));
					else
						std.textio.write(ln, str(data));
					end if;
					writeline(output_file, ln);
				end loop;

			end if;
			
		end loop;

	end process memory_simulation;

	stim_proc : process is
	begin
		rst <= '1';
		wait until rising_edge(clk);
		rst <= '0';

		in_control.go <= '1';

		in_data.address           <= X"0000_000A";
		in_data.instruction.pc    <= X"0000_0010";
		in_data.instruction.op    <= LOAD_M;
		in_data.instruction.r3    <= B"00111";
		in_data.instruction.valid <= '1';
		in_data.reg_value         <= X"1234_5678"; -- ali nije bitno kod load

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		in_control.go <= '1';

		in_data.address           <= X"0000_000A";
		in_data.instruction.pc    <= X"0000_0010";
		in_data.instruction.op    <= STORE_M;
		in_data.instruction.r3    <= B"00111";
		in_data.instruction.valid <= '1';
		in_data.reg_value         <= X"1002_f00f";

		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);

		in_control.go <= '0';

		in_data.address           <= X"0000_000A";
		in_data.instruction.pc    <= X"0000_0012";
		in_data.instruction.op    <= STORE_M;
		in_data.instruction.r3    <= B"01000";
		in_data.instruction.valid <= '1';
		in_data.reg_value         <= X"AABB_7788";

		wait until rising_edge(clk);

		wait;

	end process stim_proc;

end architecture test_arch;

