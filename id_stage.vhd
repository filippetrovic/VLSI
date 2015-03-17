library ieee;
use ieee.std_logic_1164.all;
use work.vlsi_pkg.all;

entity id_stage is
	port (
		clk : in std_logic;
		rst : in std_logic;
		in_data: in id_data_in_t;
		out_data: out id_data_out_t;
		in_control: in id_control_in_t;
		out_control: out id_control_out_t
	);
end entity id_stage;

architecture RTL of id_stage is
	type stage_buff_register_t is record
		instructions: decoded_instruction_array_t;
	end record stage_buff_register_t;
	
--	registri na izlazu iz ID
	signal stage_buff_reg, stage_buff_next : stage_buff_register_t;

	signal out_data_tmp: id_data_out_t; 
	signal out_control_tmp: id_control_out_t; 
	
--	sve na 0
	function reset_stage_buffer return stage_buff_register_t is
		variable to_ret : stage_buff_register_t;
	begin
		for i in to_ret.instructions'range loop
			to_ret.instructions(i).imm := (others => '0');
			to_ret.instructions(i).offset := (others => '0');
			to_ret.instructions(i).op := ERROR_M;
			to_ret.instructions(i).pc := (others => '0');
			to_ret.instructions(i).r1 := (others => '0');
			to_ret.instructions(i).r2 := (others => '0');
			to_ret.instructions(i).r3 := (others => '0');
		end loop;
		
		return to_ret;
	end function reset_stage_buffer;
	
	function decode (undecoded : undecoded_instruction_array_t)
		return stage_buff_register_t is
		
		variable ret: stage_buff_register_t;
	begin
		for i in undecoded'range loop
			ret.instructions(i).pc := undecoded(i).pc;
			ret.instructions(i).imm := undecoded(i).instruction(16 downto 0);
			ret.instructions(i).offset := undecoded(i).instruction(26 downto 0);
			ret.instructions(i).r1 := undecoded(i).instruction(26 downto 22);
			ret.instructions(i).r2 := undecoded(i).instruction(16 downto 12);
			ret.instructions(i).r3 := undecoded(i).instruction(21 downto 17);
			ret.instructions(i).valid := undecoded(i).valid;
			
			case undecoded(i).instruction(31 downto 27) is
				when "00000" => ret.instructions(i).op := AND_M;
				when "00001" => ret.instructions(i).op := SUB_M;
				when "00010" => ret.instructions(i).op := ADD_M;
				when "00011" => ret.instructions(i).op := ADC_M;
				when "00100" => ret.instructions(i).op := SBC_M;
				when "00101" => ret.instructions(i).op := CMP_M;
				when "00110" => ret.instructions(i).op := SSUB_M;
				when "00111" => ret.instructions(i).op := SADD_M;
				when "01000" => ret.instructions(i).op := SADC_M;
				when "01001" => ret.instructions(i).op := SSBC_M;
				when "01010" => ret.instructions(i).op := MOV_M;
				when "01011" => ret.instructions(i).op := NOT_M;
				when "01100" => ret.instructions(i).op := SL_M;
				when "01101" => ret.instructions(i).op := SR_M;
				when "01110" => ret.instructions(i).op := ASR_M;
					
				when "01111" => ret.instructions(i).op := MOV_M;
				when "10000" => ret.instructions(i).op := SMOV_M;
					
				when "10100" => ret.instructions(i).op := LOAD_M;
				when "10101" => ret.instructions(i).op := STORE_M;
					
				when "11000" => ret.instructions(i).op := BEQ_M;
				when "11001" => ret.instructions(i).op := BGT_M;
				when "11010" => ret.instructions(i).op := BHI_M;
				when "11011" => ret.instructions(i).op := BAL_M;
				when "11100" => ret.instructions(i).op := BLAL_M;
					
				when "11111" => ret.instructions(i).op := STOP_M;
				when others => ret.instructions(i).op := ERROR_M;
			end case;
			
		end loop;
		
		return ret;
	end function decode;
	
begin
	clock : process (clk, rst) is
	begin
		if rst = '1' then
			stage_buff_reg <= reset_stage_buffer;
		elsif rising_edge(clk) then
			stage_buff_reg <= stage_buff_next;
		end if;
	end process clock;
	
	out_control <= out_control_tmp;
	out_data <= out_data_tmp;
	
	comb : process(stage_buff_reg, in_control, in_data) is
	begin
		stage_buff_next <= stage_buff_reg;
		out_control_tmp.stall <= '0';
		
		if in_control.jump = '1' then
--			u istom taktu valid na izlazu <= 0
			for i in out_data_tmp.instructions'range loop
				out_data_tmp.instructions(i).valid <= '0';
			end loop;
		elsif in_control.stall = '1' then
			out_control_tmp.stall <= '1';
			stage_buff_next <= stage_buff_reg;
		else
			stage_buff_next <= decode(in_data.instructions);
		end if;
		
	end process comb;
	
end architecture RTL;
