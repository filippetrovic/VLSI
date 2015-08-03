library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

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

	signal read, write : std_logic;
	signal mem_data    : word_t;
	signal mem_address : address_t;

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
	in_data.data <= mem_data;

	memory_simulation : process is
		variable data : word_t;
	begin
		loop
			wait until rising_edge(clk);
			if read = '1' then
				-- posto nemamo simuliranu memoriju ovde onda vracamo adresu
				-- sa koje treba da procitamo podatak
				data := mem_address;
				wait until rising_edge(clk); -- vreme
				wait until rising_edge(clk); -- odziva
				wait until rising_edge(clk); -- memorije
				mem_data <= data;
			elsif write = '1' then
				wait until rising_edge(clk); -- vreme
				wait until rising_edge(clk); -- odziva
				wait until rising_edge(clk); -- memorije				
			end if;
		end loop;

	end process memory_simulation;

	stim_proc : process is
	begin
		rst <= '1';
		wait until rising_edge(clk);
		rst <= '0';

		in_control.go <= '1';

		in_data.address           <= X"0C00_00A0";
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

		in_data.address           <= X"0C00_00A0";
		in_data.instruction.pc    <= X"0000_0010";
		in_data.instruction.op    <= STORE_M;
		in_data.instruction.r3    <= B"00111";
		in_data.instruction.valid <= '1';
		in_data.reg_value         <= X"1234_5678";
		
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);
		wait until rising_edge(clk);		

		in_control.go <= '0';	
		
		in_data.address           <= X"0E00_00A0";
		in_data.instruction.pc    <= X"0000_0012";
		in_data.instruction.op    <= STORE_M;
		in_data.instruction.r3    <= B"01000";
		in_data.instruction.valid <= '1';
		in_data.reg_value         <= X"AABB_7788";
		
		wait until rising_edge(clk);		

		wait;

	end process stim_proc;

end architecture test_arch;

