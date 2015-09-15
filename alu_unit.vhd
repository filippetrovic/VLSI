library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity alu_unit is
	port(
		clk        : in  std_logic;
		rst        : in  std_logic;
		in_control : in  alu_in_control_t;
		in_data    : in  alu_in_data_t;
		out_data   : out alu_out_data_t
	);
end entity alu_unit;

architecture arch of alu_unit is
	function reset_outputs return alu_out_data_t is
		variable result : alu_out_data_t;
	begin
		result.result.address := (others => '-');
		result.result.pc      := (others => '-');
		result.result.value   := (others => '-');
		result.result.valid   := '0';
		result.psw.psw_value  := (others => '-');
		result.psw.update_psw := '0';
		return result;
	end function reset_outputs;

	signal in_buffer : alu_in_data_t;
	signal active    : std_logic;

begin
	process(clk, rst, in_buffer, in_data.psw, active) is
		variable result   : gp_register;
		variable opA      : gp_register;
		variable opB      : gp_register;
		variable c_result : std_logic_vector(REGISTER_WIDTH downto 0);
		variable to_shift : integer;

	begin
		if rst = '1' then
			out_data <= reset_outputs;
		elsif rising_edge(clk) then
			if in_control.go = '1' then
				in_buffer <= in_data;
				active    <= '1';
			else
				active <= '0';
			end if;
		end if;

		to_shift := 0;
		opA      := (others => '-');
		opB      := (others => '-');
		result   := (others => '-');
		c_result := (others => '-');

		if std2bool(active) and (in_buffer.instruction.valid = '1') then
			out_data.result.valid   <= '1';
			out_data.result.address <= in_buffer.instruction.r3;
			out_data.result.pc      <= in_buffer.instruction.pc;
			out_data.psw.psw_value  <= (others => '0');
			out_data.psw.update_psw <= '0';

			opA := in_buffer.operand_A.out_value;
			opB := in_buffer.operand_B.out_value;

			-- broj mesta za koji radimo pomeranje
			to_shift := to_integer(unsigned(opA)) mod gp_register'length;

			case in_buffer.instruction.op is
				when AND_M =>
					result                := opA and opB;
					out_data.result.value <= result;
				when SUB_M =>
					result                := std_logic_vector(unsigned(opA) - unsigned(opB));
					out_data.result.value <= result;
				when ADD_M =>
					c_result              := std_logic_vector(unsigned('0' & opA) + unsigned(opB));
					out_data.result.value <= c_result(REGISTER_WIDTH - 1 downto 0);
				when ADC_M =>
					if std2bool(in_data.psw(C_POSITION)) then
						c_result := std_logic_vector(unsigned('0' & opA) + unsigned(opB) + 1);
					else
						c_result := std_logic_vector(unsigned('0' & opA) + unsigned(opB));
					end if;
					out_data.result.value <= c_result(REGISTER_WIDTH - 1 downto 0);
				when SBC_M =>
					if not std2bool(in_data.psw(C_POSITION)) then
						result := std_logic_vector(unsigned(opA) - unsigned(opB));
					else
						result := std_logic_vector(unsigned(opA) - unsigned(opB) - 1);
					end if;
					out_data.result.value <= result;
				when CMP_M =>
					result                := std_logic_vector(signed(opA) - signed(opB));
					-- nema cuvanja rezultata
					out_data.result.valid <= '0';
					-- nije bitno sta je podatak
					out_data.result.value <= (others => '-');
				when SSUB_M =>
					result                := std_logic_vector(signed(opA) - signed(opB));
					out_data.result.value <= result;
				when SADD_M =>
					result                := std_logic_vector(signed(opA) + signed(opB));
					out_data.result.value <= result;
				when SADC_M =>
					if std2bool(in_data.psw(C_POSITION)) then
						result := std_logic_vector(signed(opA) + signed(opB) + 1);
					else
						result := std_logic_vector(signed(opA) + signed(opB));
					end if;
					out_data.result.value <= result;
				when SSBC_M =>
					if not std2bool(in_data.psw(C_POSITION)) then
						result := std_logic_vector(signed(opA) - signed(opB));
					else
						result := std_logic_vector(signed(opA) - signed(opB) - 1);
					end if;
					out_data.result.value <= result;
				when MOV_M =>
					out_data.result.value <= opB;
				when NOT_M =>
					out_data.result.value <= not opB;
				when SL_M =>
					out_data.result.value <= std_logic_vector(shift_left(unsigned(opB), to_shift));
				when SR_M =>
					out_data.result.value <= std_logic_vector(shift_right(unsigned(opB), to_shift));
				when ASR_M =>
					out_data.result.value <= std_logic_vector(shift_right(signed(opB), to_shift));
				when IMOV_M =>
					out_data.result.value <= std_logic_vector(resize(unsigned(in_buffer.instruction.imm), gp_register'length));
				when SIMOV_M =>
					out_data.result.value <= std_logic_vector(resize(signed(in_buffer.instruction.imm), gp_register'length));
				when others =>
					out_data.result.value <= (others => '-');
			end case;

			-- Postavljanje flegova
			case in_buffer.instruction.op is
				when SUB_M | SBC_M =>
					out_data.psw.update_psw <= '1';

					if unsigned(result) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					if opA(opA'left) = '0' and opB(opB'left) = '1' then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;
					if opA(opA'left) = '0' and result(result'left) = '1' then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;
					if opB(opB'left) = '1' and result(result'left) = '1' then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

				when ADD_M | ADC_M =>
					out_data.psw.update_psw <= '1';

					if unsigned(c_result(REGISTER_WIDTH - 1 downto 0)) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					out_data.psw.psw_value(C_POSITION) <= c_result(REGISTER_WIDTH);
				when CMP_M | SSUB_M | SSBC_M =>
					out_data.psw.update_psw <= '1';

					if signed(result) < 0 then
						out_data.psw.psw_value(N_POSITION) <= '1';
					end if;

					if unsigned(result) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					if (opA(opA'left) = '0' and opB(opB'left) = '1') then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;
					if (opB(opB'left) = '1' and result(result'left) = '1') then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;
					if (opA(opA'left) = '0' and result(result'left) = '1') then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

					if (opA(opA'left) = '0') and (opB(opB'left) = '1') and (result(result'left) = '1') then
						out_data.psw.psw_value(V_POSITION) <= '1';
					end if;
					if (opA(opA'left) = '1') and (opB(opB'left) = '0') and (result(result'left) = '0') then
						out_data.psw.psw_value(V_POSITION) <= '1';
					end if;

				when SADD_M | SADC_M =>
					out_data.psw.update_psw <= '1';

					if signed(result) < 0 then
						out_data.psw.psw_value(N_POSITION) <= '1';
					end if;

					if unsigned(result) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					if (opA(opA'left) = '1' and opB(opB'left) = '1') then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;
					if (opB(opB'left) = '1' and result(result'left) = '0') then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;
					if (opA(opA'left) = '1' and result(result'left) = '0') then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

					if (opA(opA'left) = '0') and (opB(opB'left) = '0') and (result(result'left) = '1') then
						out_data.psw.psw_value(V_POSITION) <= '1';
					end if;
					if (opA(opA'left) = '1') and (opB(opB'left) = '1') and (result(result'left) = '0') then
						out_data.psw.psw_value(V_POSITION) <= '1';
					end if;

				when others =>
					-- ostale instrukcije ne uticu na flegove
					out_data.psw.update_psw <= '0';
					out_data.psw.psw_value  <= (others => '-');
			end case;

		else
			-- ukoliko ALU nije primila go signal out_data <= reset_outputs;
			out_data                <= reset_outputs;
			out_data.result.valid   <= '0';
			out_data.psw.update_psw <= '0';
		end if;

	end process;

end architecture arch;

