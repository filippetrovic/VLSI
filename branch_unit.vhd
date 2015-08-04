library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity branch_unit is
	port(
		clk         : in  std_logic;
		rst         : in  std_logic;
		control_in  : in  branch_unit_control_in_t;
		data_in     : in  branch_unit_data_in_t;
		data_out    : out branch_unit_data_out_t;
		control_out : out branch_unit_control_out_t
	);
end entity branch_unit;

architecture arch of branch_unit is
	function calc_jump_address(pc : address_t; offset : jump_offset_t) return address_t is
		variable jump_address : address_t;
		variable s_offset     : integer;
	begin
		s_offset     := to_integer(signed(std_logic_vector(resize(signed(offset), address_t'length))));
		jump_address := std_logic_vector(to_unsigned(to_integer(unsigned(pc) + 1) + s_offset, address_t'length));
		return jump_address;

	end function calc_jump_address;

	function reset_data_out return branch_unit_data_out_t is
		variable data_out_reset : branch_unit_data_out_t;
	begin
		data_out_reset.jump_address := (others => '0');
		data_out_reset.link_address := (others => '0');
		data_out_reset.pc := (others => '0');
		return data_out_reset;
	end function reset_data_out;

	signal N, Z, C, V : std_logic;

	signal jump, wr     : std_logic;
	signal jump_address : address_t;
	signal link_address : address_t;

	signal in_buffer : branch_unit_data_in_t;
	signal in_ctrl_buffer : branch_unit_control_in_t;

begin
	process(clk) is
	begin
		if rising_edge(clk) then
			in_buffer <= data_in;
			in_ctrl_buffer <= control_in;
		end if;
	end process;

	N <= in_buffer.psw(N_POSITION);
	Z <= in_buffer.psw(Z_POSITION);
	C <= in_buffer.psw(C_POSITION);
	V <= in_buffer.psw(V_POSITION);

	ctrl : process(C, N, V, Z, jump, jump_address, link_address, wr, in_ctrl_buffer.go, in_buffer, rst) is
	begin
		
		wr           <= '0';
		jump         <= '0';
		jump_address <= (others => '0');
		link_address <= (others => '0');

		if rst = '1' then
			
			control_out.jump <= '0';
			control_out.wr   <= '0';
			data_out         <= reset_data_out;

		elsif (in_buffer.instruction.valid = '1') and (in_ctrl_buffer.go = '1') then
			case in_buffer.instruction.op is
				when BEQ_M =>
					if std2bool(Z) then
						jump         <= '1';
						jump_address <= calc_jump_address(in_buffer.instruction.pc, in_buffer.instruction.offset);
						link_address <= (others => '-');
					end if;
				when BGT_M =>
					if not (std2bool(Z) or (std2bool(N) xor std2bool(V))) then
						jump         <= '1';
						jump_address <= calc_jump_address(in_buffer.instruction.pc, in_buffer.instruction.offset);
						link_address <= (others => '-');
					end if;
				when BHI_M =>
					if std2bool(C) and not (std2bool(Z)) then
						jump         <= '1';
						jump_address <= calc_jump_address(in_buffer.instruction.pc, in_buffer.instruction.offset);
						link_address <= (others => '-');
					end if;
				when BAL_M =>
					jump         <= '1';
					jump_address <= calc_jump_address(in_buffer.instruction.pc, in_buffer.instruction.offset);
					link_address <= (others => '-');
				when BLAL_M =>
					wr           <= '1';
					jump         <= '1';
					jump_address <= calc_jump_address(in_buffer.instruction.pc, in_buffer.instruction.offset);
					link_address <= std_logic_vector(unsigned(in_buffer.instruction.pc) + 1);
				when others =>
					null;
			end case;

			control_out.jump      <= jump;
			control_out.wr        <= wr;
			data_out.jump_address <= jump_address;
			data_out.link_address <= link_address;
			data_out.pc	<= in_buffer.instruction.pc;
		else
			
			control_out.jump <= '0';
			control_out.wr   <= '0';
			data_out         <= reset_data_out;

		end if;

	end process ctrl;

end architecture arch;

