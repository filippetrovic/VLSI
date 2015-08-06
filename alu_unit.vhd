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

	signal go        : std_logic;
	signal in_buffer : alu_in_data_t;

begin
	process(clk, rst, go, in_buffer, in_data.psw) is
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
				go        <= '1';
			else
				go <= '0';
			end if;
		end if;

		if std2bool(go) and (in_buffer.instruction.valid = '1') then
			out_data.result.valid   <= '1';
			out_data.result.address <= in_buffer.instruction.r3;
			out_data.result.pc      <= in_buffer.instruction.pc;
			out_data.psw.psw_value  <= (others => '0');
			out_data.psw.update_psw <= '0';

			-- broj mesta za koji radimo pomeranje
			to_shift := to_integer(unsigned(in_buffer.operand_A.out_value)) mod gp_register'length;

			case in_buffer.instruction.op is
				when AND_M =>
					out_data.result.value <= in_buffer.operand_A.out_value and in_buffer.operand_B.out_value;

				when SUB_M =>
					result := std_logic_vector(
							unsigned(in_buffer.operand_A.out_value) - unsigned(in_buffer.operand_B.out_value)
						);

					out_data.psw.update_psw <= '1';

					if unsigned(result) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					opA := in_buffer.operand_A.out_value;
					opB := in_buffer.operand_B.out_value;

					if opA(opA'left) = '0' and opB(opB'left) = '1' then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

					if opA(opA'left) = '0' and result(result'left) = '1' then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

					if opB(opB'left) = '1' and result(result'left) = '1' then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

					out_data.result.value <= result;

				when ADD_M =>
					c_result := std_logic_vector(
							unsigned('0' & in_buffer.operand_A.out_value) + unsigned(in_buffer.operand_B.out_value)
						);

					out_data.psw.update_psw <= '1';

					if unsigned(c_result(REGISTER_WIDTH - 1 downto 0)) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					out_data.psw.psw_value(C_POSITION) <= c_result(REGISTER_WIDTH);

					out_data.result.value <= c_result(REGISTER_WIDTH - 1 downto 0);
				when ADC_M =>
					if std2bool(in_data.psw(C_POSITION)) then
						c_result := std_logic_vector(
								unsigned('0' & in_buffer.operand_A.out_value) + unsigned(in_buffer.operand_B.out_value) + 1
							);
					else
						c_result := std_logic_vector(
								unsigned('0' & in_buffer.operand_A.out_value) + unsigned(in_buffer.operand_B.out_value)
							);
					end if;

					out_data.psw.update_psw <= '1';

					if unsigned(c_result(REGISTER_WIDTH - 1 downto 0)) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					out_data.psw.psw_value(C_POSITION) <= c_result(REGISTER_WIDTH);

					out_data.result.value <= c_result(REGISTER_WIDTH - 1 downto 0);
				when SBC_M =>
					if std2bool(in_data.psw(C_POSITION)) then
						result := std_logic_vector(
								unsigned(in_buffer.operand_A.out_value) - unsigned(in_buffer.operand_B.out_value)
							);
					else
						result := std_logic_vector(
								unsigned(in_buffer.operand_A.out_value) - unsigned(in_buffer.operand_B.out_value) - 1
							);
					end if;

					out_data.psw.update_psw <= '1';

					if unsigned(result) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					opA := in_buffer.operand_A.out_value;
					opB := in_buffer.operand_B.out_value;

					if (opA(opA'left) = '0' and opB(opB'left) = '1') then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

					if (opB(opB'left) = '1' and result(result'left) = '1') then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

					if (opA(opA'left) = '0' and result(result'left) = '1') then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

					out_data.result.value <= result;

				when CMP_M =>
					result := std_logic_vector(
							unsigned(in_buffer.operand_A.out_value) - unsigned(in_buffer.operand_B.out_value)
						);

					out_data.psw.update_psw <= '1';

					if unsigned(result) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					opA := in_buffer.operand_A.out_value;
					opB := in_buffer.operand_B.out_value;

					if opA(opA'left) = '0' and opB(opB'left) = '1' then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

					if opA(opA'left) = '0' and result(result'left) = '1' then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

					if opB(opB'left) = '1' and result(result'left) = '1' then
						out_data.psw.psw_value(C_POSITION) <= '1';
					end if;

					-- nema cuvanja rezultata
					out_data.result.valid <= '0';
					-- nije bitno sta je podatak
					out_data.result.value <= (others => '-');
				when SSUB_M =>
					result := std_logic_vector(
							signed(in_buffer.operand_A.out_value) - signed(in_buffer.operand_B.out_value)
						);

					out_data.psw.update_psw <= '1';

					if signed(result) < 0 then
						out_data.psw.psw_value(N_POSITION) <= '1';
					end if;

					if unsigned(result) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					opA := in_buffer.operand_A.out_value;
					opB := in_buffer.operand_B.out_value;

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

					out_data.result.value <= result;
				when SADD_M =>
					result := std_logic_vector(
							signed(in_buffer.operand_A.out_value) + signed(in_buffer.operand_B.out_value)
						);

					out_data.psw.update_psw <= '1';

					if signed(result) < 0 then
						out_data.psw.psw_value(N_POSITION) <= '1';
					end if;

					if unsigned(result) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					opA := in_buffer.operand_A.out_value;
					opB := in_buffer.operand_B.out_value;

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

					out_data.result.value <= result;
				when SADC_M =>
					if std2bool(in_data.psw(C_POSITION)) then
						result := std_logic_vector(
								signed(in_buffer.operand_A.out_value) + signed(in_buffer.operand_B.out_value) + 1
							);
					else
						result := std_logic_vector(
								signed(in_buffer.operand_A.out_value) + signed(in_buffer.operand_B.out_value)
							);
					end if;

					out_data.psw.update_psw <= '1';

					if signed(result) < 0 then
						out_data.psw.psw_value(N_POSITION) <= '1';
					end if;

					if unsigned(result) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					opA := in_buffer.operand_A.out_value;
					opB := in_buffer.operand_B.out_value;
					
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

					out_data.result.value <= result;

				when SSBC_M =>
					if std2bool(in_data.psw(C_POSITION)) then
						result := std_logic_vector(
								signed(in_buffer.operand_A.out_value) - signed(in_buffer.operand_B.out_value)
							);
					else
						result := std_logic_vector(
								signed(in_buffer.operand_A.out_value) - signed(in_buffer.operand_B.out_value) - 1
							);
					end if;

					out_data.psw.update_psw <= '1';

					if signed(result) < 0 then
						out_data.psw.psw_value(N_POSITION) <= '1';
					end if;

					if unsigned(result) = 0 then
						out_data.psw.psw_value(Z_POSITION) <= '1';
					end if;

					opA := in_buffer.operand_A.out_value;
					opB := in_buffer.operand_B.out_value;
					
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

					out_data.result.value <= result;
				when MOV_M =>
					out_data.result.value <= in_buffer.operand_B.out_value;
				when NOT_M =>
					out_data.result.value <= not in_buffer.operand_B.out_value;
				when SL_M =>
					out_data.result.value <= std_logic_vector(shift_left(unsigned(in_buffer.operand_B.out_value), to_shift));
				when SR_M =>
					out_data.result.value <= std_logic_vector(shift_right(unsigned(in_buffer.operand_B.out_value), to_shift));
				when ASR_M =>
					out_data.result.value <= std_logic_vector(shift_right(signed(in_buffer.operand_B.out_value), to_shift));
				when IMOV_M =>
					out_data.result.value <= std_logic_vector(resize(unsigned(in_buffer.instruction.imm), gp_register'length));
				when SIMOV_M =>
					out_data.result.value <= std_logic_vector(resize(signed(in_buffer.instruction.imm), gp_register'length));
				when others =>
					out_data.result.value   <= (others => '-');
					out_data.psw.psw_value  <= (others => '-');
					out_data.psw.update_psw <= '0';
			end case;

		else
			out_data                <= reset_outputs;
			out_data.result.valid   <= '0';
			out_data.psw.update_psw <= '0';

		end if;

	end process;

end architecture arch;

