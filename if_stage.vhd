library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.vlsi_pkg.all;

entity if_stage is
	port (
		clk : in std_logic;
		reset: in std_logic;
		in_data: in if_data_in_t;
		out_data: out if_data_out_t;
		in_control: in if_control_in_t;
		out_control: out if_control_out_t
	);
end entity if_stage;

architecture RTL of if_stage is
	type pc_register_t is record
		pc: address_t;
	end record pc_register_t;
	
	type inst_register_t is record
		instructions: undecoded_instruction_array_t;
	end record inst_register_t;
	
	signal pc_reg, pc_next: pc_register_t;
	signal last_pc_reg, last_pc_next: pc_register_t;
	signal stage_buf_reg, stage_buf_next: inst_register_t;
	
	function reset_pc return pc_register_t is
		variable to_ret : pc_register_t;
	begin
		to_ret.pc := (others => '0');
		return to_ret;
	end function reset_pc;
	
	signal out_data_tmp: if_data_out_t;
	signal out_control_tmp: if_control_out_t;
	
	signal delayed_jump_signal_ff: std_logic;
begin
	
	clk_proc : process (clk, reset) is
	begin
		if reset = '1' then
--			out_control.valid <= '0';
			pc_reg <= reset_pc;
			last_pc_reg <= reset_pc;
		elsif rising_edge(clk) then
			pc_reg <= pc_next;
			stage_buf_reg <= stage_buf_next;
			last_pc_reg <= last_pc_next;
		end if;
	end process clk_proc;
	
	out_control <= out_control_tmp;
	out_data <= out_data_tmp;
	
	comb : process (pc_reg, stage_buf_reg, in_data, in_control, last_pc_reg) is
	begin
		pc_next <= pc_reg;
		stage_buf_next <= stage_buf_reg;
		last_pc_next <= last_pc_reg;
		
--		data lines from IF to ID (from stage_buf)
		for i in out_data_tmp.instructions'range loop
			out_data_tmp.instructions(i).instruction <= stage_buf_reg.instructions(i).instruction;
			out_data_tmp.instructions(i).pc <= stage_buf_reg.instructions(i).pc;
		end loop;
		
--		data lines from MEM to IF (saved in stage_buf)
		for i in in_data.mem_values'range loop
			stage_buf_next.instructions(i).instruction <= in_data.mem_values(i);
			stage_buf_next.instructions(i).pc <= unsigned_add(last_pc_reg.pc, i);
		end loop;
		
		if in_control.jump = '1' then
			pc_next.pc <= in_data.jump_address;
			out_control_tmp.read <= '1';
		else
			if in_control.stall = '1' then
				pc_next <= pc_reg;
				stage_buf_next <= stage_buf_reg;
				last_pc_next <= last_pc_reg;
				out_control_tmp.read <= '0';
			else
				last_pc_next.pc <= pc_reg.pc;
				pc_next.pc <= unsigned_add(pc_reg.pc, ISSUE_WIDTH);
				out_control_tmp.read <= '1';
			end if;		
		end if;
		
		
		
	end process comb;
	
--	jump signal iz brunch jedinicice (in_control.jump) traje jednu periodu takta. Znaci da su nama podaci nevalidni kada je 
--	in_control.jump == '0' i u sledecem taktu (tada iz memorije pristize nesto sto nam ne treba). Zato postoji valid_ff.
	
	out_control_tmp.valid <= 	'0' when in_control.jump = '1' OR delayed_jump_signal_ff = '1' else
								'1';
	
	validff : process (clk) is
	begin
		if (rising_edge(clk)) then
			delayed_jump_signal_ff <= in_control.jump;
		end if;
	end process validff;
end architecture RTL;
