library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity if_stage is
	port(
		clk         : in  std_logic;
		reset       : in  std_logic;
		control_in  : in  if_control_in_t;
		data_in     : in  if_data_in_t;
		control_out : out if_control_out_t;
		data_out    : out if_data_out_t
	);
end entity if_stage;

architecture arch of if_stage is
	type state is (reseted, working);
	signal state_reg, state_next : state;

	signal inc_pc        : std_logic;
	signal ld_pc         : std_logic;
	signal new_pc        : address_t;
	signal data_out_reg  : if_data_out_t;
	signal data_out_next : if_data_out_t;
	signal last_pc       : address_array_t;
	signal current_pc    : address_array_t;

	function reset_stage_buffer return if_data_out_t is
		variable buff : if_data_out_t;
	begin
		buff.addresses := (others => (others => '0'));
		for i in buff.instructions'range loop
			buff.instructions(i).pc          := (others => '0');
			buff.instructions(i).instruction := (others => '0');
			buff.instructions(i).valid       := '0';
		end loop;
		return buff;
	end function reset_stage_buffer;

begin
	pc_reg : entity work.pc_reg
		port map(
			clk => clk,
			inc => inc_pc,
			ld  => ld_pc,
			d   => new_pc,
			q   => current_pc,
			p   => last_pc
		);

	process(clk, reset, control_in.jump, current_pc, data_in, data_out_next, state_reg) is
	begin
		ld_pc        <= '0';
		new_pc       <= (others => '-');
		data_out_reg <= data_out_next;

		if reset = '1' then
			ld_pc         <= '1';
			new_pc        <= data_in.init_pc;
			data_out_next <= reset_stage_buffer;
			state_reg     <= reseted;

		elsif rising_edge(clk) then
			if state_reg /= reseted then
				for i in data_out.instructions'range loop
					data_out_next.instructions(i).pc          <= last_pc(i);
					data_out_next.instructions(i).instruction <= data_in.mem_values(i);
					data_out_next.instructions(i).valid       <= '1';
				end loop;
			end if;
			if (control_in.stall = '1') or (control_in.jump = '1') then
				data_out_next <= data_out_reg;
			else
				state_reg <= state_next;
			end if;
		end if;

		if control_in.jump = '1' then
			ld_pc                              <= '1';
			data_out_reg.instructions(0).valid <= '0';
			data_out_reg.instructions(1).valid <= '0';
			data_out_next.addresses(0)         <= data_in.jump_address;
			data_out_next.addresses(1)         <= std_logic_vector(unsigned(data_in.jump_address) + 1);
			new_pc                             <= std_logic_vector(unsigned(data_in.jump_address) + 2);
		else
			data_out_next.addresses <= current_pc;
		end if;

		case state_reg is
			when reseted =>
				state_next <= working;
			when working =>
				state_next <= working;
		end case;

	end process;

	data_out         <= data_out_reg;
	control_out.read <= not control_in.stall;
	inc_pc           <= not control_in.stall;

end architecture arch;