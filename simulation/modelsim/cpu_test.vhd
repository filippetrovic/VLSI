library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity cpu_test is
end entity cpu_test;

architecture test_arch of cpu_test is

	-- cache constants, signals and types
	constant MEM_SIZE : natural := 2 ** 12;

	type cache_mem_t is array (0 to MEM_SIZE - 1) of word_t;

	signal inst_cache : cache_mem_t := (others => (others => 'X'));
	signal data_cache : cache_mem_t := (others => (others => 'X'));

	-- marker signali
	signal inst_init_done : std_logic := '0';
	signal data_init_done : std_logic := '0';

	-- kontrolni signali
	signal ic_read  : std_logic;
	signal dc_read  : std_logic;
	signal dc_write : std_logic;

	-- adrese
	signal ic_ext_address : address_array_t;
	signal dc_ext_address : address_t;
	-- podaci
	signal ic_data_out    : word_array_t;
	signal dc_data_in     : word_t;
	signal dc_data_out    : word_t;
	-- cache constants, signals and types end

	signal clk, rst : std_logic;

	-- pocetna adresa od koje procesor
	-- pocinje da izvrsava instrukcije
	signal init_pc : address_t;

	-- stop signal od procesora
	signal cpu_stop : std_logic;

	impure function ld_mem(file f : text) return cache_mem_t is
		variable mem        : cache_mem_t;
		variable ln         : line;
		variable dc_address : address_t;
		variable dc_data    : word_t;
	begin
		while not endfile(f) loop

			-- citamo narednu liniju fajla
			readline(f, ln);
			-- citamo adresu podatka
			hread(ln, dc_address);
			-- citamo podatak
			read(ln, dc_data);

			mem(to_integer(unsigned(dc_address))) := dc_data;

		end loop;

		return mem;

	end function ld_mem;

	signal cpu_in_data     : cpu_in_data_t;
	signal cpu_out_data    : cpu_out_data_t;
	signal cpu_out_control : cpu_out_control_t;

begin
	clock_driver : process
		constant period : time := CLK_PERIOD;
	begin
		clk <= '0';
		wait for period / 2;
		clk <= '1';
		wait for period / 2;
	end process clock_driver;

	dut : entity work.cpu
		port map(
			clk             => clk,
			rst             => rst,
			cpu_in_data     => cpu_in_data,
			cpu_out_data    => cpu_out_data,
			cpu_out_control => cpu_out_control
		);

	cpu_in_data.init_pc    <= init_pc;
	cpu_in_data.mem_data   <= dc_data_out;
	cpu_in_data.mem_values <= ic_data_out;

	ic_ext_address <= cpu_out_data.inst_address;
	dc_ext_address <= cpu_out_data.mem_address;
	dc_data_in     <= cpu_out_data.mem_data;
	
	ic_read <= cpu_out_control.read_inst;
	dc_read <= cpu_out_control.read_data;
	dc_write <= cpu_out_control.write_data;
	
	cpu_stop <= cpu_out_control.stop;

	-- proces kojim simuliramo instrukcijski kes
	init_inst_cache : process is
		file inst_cache_file : text open read_mode is "inst_cache.txt";

		variable ln         : line;
		variable ic_address : address_t;

	begin

		-- resetujemo procesor
		rst <= '0';

		readline(inst_cache_file, ln);
		hread(ln, ic_address);

		-- postavljamo pocetnu adresu
		-- kojom se inicijalizuje pc procesora
		init_pc <= ic_address;

		-- inicijalizujemo instrukcijasku kes memoriju iz fajla
		inst_cache <= ld_mem(inst_cache_file);

		wait for CLK_PERIOD;

		-- ukidamo reset signal
		rst <= '0';

		-- oznacavamo da je inicijalizacija kesa zavrsena
		inst_init_done <= '1';

		-- odgovara u jednom taktu
		read : loop
			wait until rising_edge(clk);

			if ic_read = '1' then
				for i in word_array_t'range loop
					ic_data_out(i) <= inst_cache(to_integer(unsigned(ic_ext_address(i))));
				end loop;
			end if;

		end loop read;

	end process init_inst_cache;

	-- proces kojim simuliramo data kes
	init_data_cache : process is
		file data_cache_file : text open read_mode is "data_cache.txt";

		file output_file : text is out "output.txt";

		variable ln         : line;
		variable dc_address : address_t;
		variable dc_data    : word_t;

	begin

		-- inicijalizujemo data kes memoriju iz fajla
		data_cache <= ld_mem(data_cache_file);

		-- zavrsena inicijalizacija
		data_init_done <= '1';

		-- odgovara nakon tri takta
		read_write : loop
			wait until rising_edge(clk);

			if dc_read = '1' then
				dc_address := dc_ext_address;

				-- vreme pristupa memoriji
				wait until rising_edge(clk);
				wait until rising_edge(clk);
				wait until rising_edge(clk);

				dc_data_out <= data_cache(to_integer(unsigned(dc_address)));

			elsif dc_write = '1' then
				dc_data    := dc_data_in;
				dc_address := dc_ext_address;
				-- vreme pristupa
				wait until rising_edge(clk);
				wait until rising_edge(clk);
				wait until rising_edge(clk);

				data_cache(to_integer(unsigned(dc_address))) <= dc_data;

				-- dump svega u fajl output.txt
				for i in cache_mem_t'range loop
					std.textio.write(ln, hstr(std_logic_vector(to_unsigned(i, 32))));
					std.textio.write(ln, string'(" "));
					if i /= to_integer(unsigned(dc_address)) then
						std.textio.write(ln, str(data_cache(i)));
					else
						std.textio.write(ln, str(dc_data));
					end if;
					writeline(output_file, ln);
				end loop;

			end if;

		end loop read_write;

	end process init_data_cache;

	stop_and_compare : process
		file test_cache_file : text open read_mode is "test_cache.txt";

		variable data_test : cache_mem_t := (others => (others => 'X'));
		variable matched   : boolean;

	begin
		wait until rising_edge(clk);

		-- ako je procesor zavrsio potrebno je uporediti
		-- sadrzaj memorije sa ocekivanim sadrzajem i ispisati poruku
		-- o ishodu poredjenja
		if cpu_stop = '1' then

			-- ocekivani sadrzaj
			data_test := ld_mem(test_cache_file);

			matched := true;

			for i in cache_mem_t'range loop
				if data_cache(i) /= data_test(i) then
					matched := false;
					report "Sadrzaj memorije se ne poklapa sa ocekivanim!";
					exit;
				end if;
			end loop;

			if matched then
				report "Sadrzaji se poklapaju!";
			end if;

		end if;

	end process stop_and_compare;

end architecture test_arch;

