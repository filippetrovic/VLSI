library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

--	switch je deo srednjeg dela procesora. 
--	Uloga: aktivira odgovarajucu func jedinicu u zavisnosti
--	od OP kodova instrukcija i go signala iz SM. Prosledjuje
--	dekodovani instrukciju na ulaz func jedinice.
--	Princip: Proverava go signal i da li je instrukcija validna.
--	Ako je sve u aktivno onda se instrukcija na osnovu op_coda moze proslediti.
entity switch is
	port(
		data_in    : in  switch_in_data_t;
		control_in : in  switch_in_control_t;
		data_out   : out switch_out_data_t
	);
end entity switch;

architecture RTL of switch is
	function not_important return decoded_instruction_t is
		variable ret : decoded_instruction_t;

	begin
		ret.imm    := "-----------------";
		ret.offset := "---------------------------";
		ret.op     := "-----";
		ret.pc     := "--------------------------------";
		ret.r1     := "-----";
		ret.r2     := "-----";
		ret.r3     := "-----";
		ret.valid  := '-';
		return ret;
	end function not_important;

begin

	comb : process(data_in, control_in) is
		procedure activate_func_unit(inst : in mnemonic_t; instruction_num : in integer) is
		begin
			case to_integer(unsigned(inst)) is
				when to_integer(unsigned(AND_M)) to to_integer(unsigned(SIMOV_M)) =>
					data_out.func_control.alu_control(instruction_num).go          <= '1';
					data_out.func_control.alu_control(instruction_num).instruction <= data_in.instructions(instruction_num);
				when to_integer(unsigned(LOAD_M)) | to_integer(unsigned(STORE_M)) =>
					data_out.func_control.mem_control.go          <= '1';
					data_out.func_control.mem_control.instruction <= data_in.instructions(instruction_num);
					data_out.r1                                   <= data_in.instructions(instruction_num).r1;
					data_out.r3                                   <= data_in.instructions(instruction_num).r3;
				when to_integer(unsigned(BEQ_M)) to to_integer(unsigned(BLAL_M)) =>
					data_out.func_control.br_control.go          <= '1';
					data_out.func_control.br_control.instruction <= data_in.instructions(instruction_num);
				when others => null;
			end case;
		end procedure activate_func_unit;
	begin
		data_out.r1 <= "-----";
		data_out.r3 <= "-----";

		for i in data_out.func_control.alu_control'range loop
			data_out.func_control.alu_control(i).go          <= '0';
			data_out.func_control.alu_control(i).instruction <= not_important;
		end loop;

		data_out.func_control.br_control.go           <= '0';
		data_out.func_control.br_control.instruction  <= not_important;
		data_out.func_control.mem_control.go          <= '0';
		data_out.func_control.mem_control.instruction <= not_important;

		if control_in.stop = '0' then
			if control_in.inst_go(0) = '1' and data_in.instructions(0).valid = '1' then
				activate_func_unit(data_in.instructions(0).op, 0);
			end if;

			if control_in.inst_go(1) = '1' and data_in.instructions(1).valid = '1' then
				activate_func_unit(data_in.instructions(1).op, 1);
			end if;
		end if;

	end process comb;

end architecture RTL;
