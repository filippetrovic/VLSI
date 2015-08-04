library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

-- id faza predstavlja drugi stepen protocne obrade.
-- id faza na svom kraju ima stage registre.
-- prihvata nedekodovanu instrukciju, deli bite po formatu instrkucije (dekoduje)
-- i to prosledjuje dalje. VAZNO: U ovoj fazi se ne dohvata vrednost operanada.
entity id_stage is
	port(
		clk         : in  std_logic;
		rst         : in  std_logic;
		data_in     : in  id_data_in_t;
		data_out    : out id_data_out_t;
		control_in  : in  id_control_in_t;
		control_out : out id_control_out_t
	);
end entity id_stage;

architecture RTL of id_stage is
	type stage_buff_register_t is record
		instructions : decoded_instruction_array_t;
	end record stage_buff_register_t;

	--	registri na izlazu iz ID
	signal stage_buff_reg, stage_buff_next : stage_buff_register_t;

	signal out_data_tmp    : id_data_out_t;
	signal out_control_tmp : id_control_out_t;

	--	sve na 0
	function reset_stage_buffer return stage_buff_register_t is
		variable to_ret : stage_buff_register_t;
	begin
		for i in to_ret.instructions'range loop
			to_ret.instructions(i).imm    := (others => '0');
			to_ret.instructions(i).offset := (others => '0');
			to_ret.instructions(i).op     := ERROR_M;
			to_ret.instructions(i).pc     := (others => '0');
			to_ret.instructions(i).r1     := (others => '0');
			to_ret.instructions(i).r2     := (others => '0');
			to_ret.instructions(i).r3     := (others => '0');
			to_ret.instructions(i).valid  := '0';
		end loop;

		return to_ret;
	end function reset_stage_buffer;

	function isOpCodeValid(op : mnemonic_t) return boolean is
	begin
		case to_integer(unsigned(op)) is
			when to_integer(unsigned(AND_M)) to to_integer(unsigned(SIMOV_M)) =>
				return true;
			when to_integer(unsigned(LOAD_M)) | to_integer(unsigned(STORE_M)) =>
				return true;
			when to_integer(unsigned(BEQ_M)) to to_integer(unsigned(BLAL_M))  =>
				return true;
			when others                                                       =>
				return false;
		end case;
	end function isOpCodeValid;

	function decode(undecoded : undecoded_instruction_array_t) return stage_buff_register_t is
		variable ret : stage_buff_register_t;
	begin
		for i in undecoded'range loop
			ret.instructions(i).pc     := undecoded(i).pc;
			ret.instructions(i).imm    := undecoded(i).instruction(16 downto 0);
			ret.instructions(i).offset := undecoded(i).instruction(26 downto 0);
			ret.instructions(i).r1     := undecoded(i).instruction(26 downto 22);
			ret.instructions(i).r2     := undecoded(i).instruction(16 downto 12);
			ret.instructions(i).r3     := undecoded(i).instruction(21 downto 17);
			ret.instructions(i).valid  := undecoded(i).valid;
			if (isOpCodeValid(undecoded(i).instruction(31 downto 27))) then
				ret.instructions(i).op := undecoded(i).instruction(31 downto 27);
			else
				ret.instructions(i).op := ERROR_M;
			end if;
		end loop;

		return ret;
	end function decode;
	
begin
	clock : process(clk, rst) is
	begin
		if rst = '1' then
			stage_buff_reg <= reset_stage_buffer;
		elsif rising_edge(clk) then
			stage_buff_reg <= stage_buff_next;
		end if;
	end process clock;

	control_out <= out_control_tmp;
	data_out    <= out_data_tmp;

	comb : process(stage_buff_reg, control_in, data_in) is
	begin
		stage_buff_next       <= decode(data_in.instructions);
		out_control_tmp.stall <= '0';

		-- Lines from ID to OF
		out_data_tmp.instructions <= stage_buff_reg.instructions;

		if control_in.jump = '1' then
			-- u istom taktu valid na izlazu <= 0
			for i in out_data_tmp.instructions'range loop
				out_data_tmp.instructions(i).valid <= '0';
			end loop;
		elsif control_in.stall = '1' then
			out_control_tmp.stall <= '1';
			stage_buff_next       <= stage_buff_reg;
		end if;

	end process comb;

end architecture RTL;
