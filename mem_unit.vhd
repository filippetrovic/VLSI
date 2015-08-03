library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity mem_unit is
	port(
		clk         : in  std_logic;
		rst         : in  std_logic;
		in_control  : in  mem_unit_control_in_t;
		in_data     : in  mem_unit_data_in_t;
		out_control : out mem_unit_control_out_t;
		out_data    : out mem_unit_data_out_t
	);
end entity mem_unit;

architecture arch of mem_unit is

	-- funkcija koja sluzi samo da se izlazi ka wsu drze na 0 dok ne postoji podatak
	-- procitan iz memorije koji je moguce proslediti ka wsu
	function reset_outputs_to_wsu return wsh_in_data_t is
		variable wsu_outputs : wsh_in_data_t;
	begin
		wsu_outputs.address := (others => '0');
		wsu_outputs.pc      := (others => '0');
		wsu_outputs.valid   := '0';
		wsu_outputs.value   := (others => '0');
		return wsu_outputs;
	end function reset_outputs_to_wsu;

	type state is (idle, busy);

	signal state_reg, state_next : state;

	-- broj taktova za koji odgovara
	-- kes memorija podataka
	constant MEM_ACCESS_TIME : positive := 3;

	signal in_buffer : mem_unit_data_in_t;

	signal count_reg, count_next : natural;

	signal mem_done_reg, mem_done_next : std_logic;

begin
	process(clk, rst) is
	begin
		if rst = '1' then
			count_reg    <= 0;
			state_reg    <= idle;
			mem_done_reg <= '0';
		elsif rising_edge(clk) then
			if state_reg = idle then
				if std2bool(in_control.go) and in_data.instruction.valid = '1' then
					in_buffer <= in_data;
					state_reg <= busy;
					count_reg <= 0;
				else
					state_reg <= idle;
				end if;
			else
				state_reg <= state_next;
				count_reg <= count_next;
			end if;
			mem_done_reg <= mem_done_next;
		end if;
	end process;

	out_control.mem_done <= mem_done_reg;

	process(state_reg, in_buffer, count_reg, in_data) is
	begin

		-- kada ne postoji prosledjivanje (nakon load-a) drzimo ove izlaze na 0
		out_data.wsu_data <= reset_outputs_to_wsu;

		-- ovo radimo kako bismo izbegli latch-eve
		out_control.rd       <= '0';
		out_control.wr       <= '0';
		out_control.mem_load <= '0';
		out_data.address     <= (others => '0');
		out_data.data        <= (others => '0');
		out_data.mem_reg     <= (others => '0');

		-- podrazumevano
		count_next    <= 0;
		-- podrazumevano
		mem_done_next <= '0';

		case state_reg is
			when idle =>
				-- mem_unit nije zauzeta i ostaje u stanju idle dok god ne primi go signal
				out_control.mem_busy <= '0';
				state_next           <= idle;
			when busy =>
				out_control.mem_busy <= '1';
				-- adresa registra sa kojim radi jedinica
				out_data.mem_reg     <= in_buffer.instruction.r3;
				-- adresu iz ulaznog bafera prosledjujemo na izlaz
				out_data.address     <= in_buffer.address;

				state_next <= busy;

				if in_buffer.instruction.op = LOAD_M then
					out_control.mem_load <= '1';
					-- rd je aktivan samo u prvom taktu busy stanja
					out_control.rd       <= '0';
					-- samo na pocetku aktiviramo signal rd u trajanju jednog takta
					if count_reg = 0 then
						-- aktiviramo rd samo u prvom taktu, u ostalim drzimo na neaktivnoj vrednosti
						out_control.rd <= '1';
					elsif count_reg = (MEM_ACCESS_TIME + 1) then
						-- aktiviramo odgovarajuce kontrolne signale i
						-- prospustamo podatak sa izlaza memorije direktno na wsu
						-- umesto da cuvamo u prihvatni bafer i onda da iz njega upisujemo u gpr
						out_data.wsu_data.address <= in_buffer.instruction.r3;
						out_data.wsu_data.pc      <= in_buffer.instruction.pc;
						out_data.wsu_data.valid   <= '1';
						out_data.wsu_data.value   <= in_data.data; -- podatak koji dobijamo iz memorije

						-- pitanje je da li moze da se ustedi takt tako sto bi se iz busy islo ponovo
						-- u busy stanje
						state_next    <= idle;
						-- ovaj signal ce da traje jedan takt nakon ukidanja mem_busy signala
						mem_done_next <= '1';
					end if;
				elsif in_data.instruction.op = STORE_M then
					out_control.mem_load <= '0';
					-- uvek na neaktivnoj vrednosti osim u prvoj periodi signala takta
					out_control.wr       <= '0';
					-- wr signal i podatak drzimo samo jednu periodu signala takta
					-- nakon toga se povlacimo i cekamo memoriju da zavsi
					if count_reg = 0 then
						out_control.wr <= '1';
						out_data.data  <= in_buffer.reg_value;
					elsif count_reg = (MEM_ACCESS_TIME - 1) then
						state_next    <= idle;
						-- ovaj signal ce da traje jedan takt nakon ukidanja mem_busy signala
						mem_done_next <= '1';
					end if;
				end if;

				count_next <= count_reg + 1;

		end case;
	end process;

end architecture arch;



















