library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity backend is
	port (
		clk : in std_logic;
		rst : in std_logic;
		in_data : in backend_in_data_t;
		out_data : out backend_out_data_t;
		out_control : out backend_out_control_t
	);
end entity backend;

architecture RTL of backend is
	
	-- alu signals
	type alu_in_control_array_t is array(0 to ALU_FUNC_NUM - 1) of alu_in_control_t;
	type alu_in_data_array_t is array(0 to ALU_FUNC_NUM - 1) of alu_in_data_t;
	type alu_out_data_array_t is array(0 to ALU_FUNC_NUM - 1) of alu_out_data_t;
	
	signal alu_in_control : alu_in_control_array_t;
	signal alu_in_data : alu_in_data_array_t;
	signal alu_out_data : alu_out_data_array_t;
	
	--	psw signals
	signal psw_in_data : psw_synch_in_data_array_t;
	signal psw_out_data : psw_register_t;
	
	--	wsu signals
	signal wsu_in_data : wsh_in_data_array_t;
	signal wsu_out_data : write_data_array_t;
	
	--	branch signals
	signal br_in_data     : branch_unit_data_in_t;
	signal br_out_data    : branch_unit_data_out_t;
	signal br_in_control  : branch_unit_control_in_t;
	signal br_out_control : branch_unit_control_out_t;
	
	-- mem signals
	signal mem_in_control  : mem_unit_control_in_t;
	signal mem_in_data     : mem_unit_data_in_t;
	signal mem_out_control : mem_unit_control_out_t;
	signal mem_out_data    : mem_unit_data_out_t;
begin
	
--	ALU
	generate_alu : for i in 0 to ALU_FUNC_NUM - 1 generate
		alu_unit_inst : entity work.alu_unit
		port map(
			clk        => clk,
			rst        => rst,
			in_control => alu_in_control(i),
			in_data    => alu_in_data(i),
			out_data   => alu_out_data(i)
		);
		
		alu_in_control(i).go <= in_data.func_control.alu_control(i).go;
		alu_in_data(i).instruction <= in_data.func_control.alu_control(i).instruction;
		alu_in_data(i).psw <= psw_out_data;
		alu_in_data(i).operand_A <= in_data.operand_values(2 * i);
		alu_in_data(i).operand_B <= in_data.operand_values(2 * i + 1);
		psw_in_data(i) <= alu_out_data(i).psw;
		wsu_in_data(i) <= alu_out_data(i).result;
	end generate generate_alu;
		
--	PSW
	psw_inst : entity work.psw
		port map(
			clk      => clk,
			rst      => rst,
			in_data  => psw_in_data,
			out_data => psw_out_data
		);
	
--	WSU
	write_sinh_unit_inst : entity work.write_sinh_unit
		port map(
			out_data => wsu_out_data,
			in_data  => wsu_in_data
		);
	
	out_data.from_wsu <= wsu_out_data;
	
--	BR
	branch_unit_inst : entity work.branch_unit
		port map(
			clk         => clk,
			rst         => rst,
			control_in  => br_in_control,
			data_in     => br_in_data,
			data_out    => br_out_data,
			control_out => br_out_control
		);
	
	br_in_control.go <= in_data.func_control.br_control.go;
	br_in_data.instruction <= in_data.func_control.br_control.instruction;
	br_in_data.psw <= psw_out_data;
	out_data.jump_address <= br_out_data.jump_address;
	out_control.jump <= br_out_control.jump;
	wsu_in_data(2).address <= "11111";
	wsu_in_data(2).pc <= br_out_data.pc;
	wsu_in_data(2).valid <= br_out_control.wr;
	wsu_in_data(2).value <= br_out_data.link_address;
	
--	MEM
	mem_unit_inst : entity work.mem_unit
		port map(
			clk         => clk,
			rst         => rst,
			in_control  => mem_in_control,
			in_data     => mem_in_data,
			out_control => mem_out_control,
			out_data    => mem_out_data
		);
		
	mem_in_control.go <= in_data.func_control.mem_control.go; 
	mem_in_data.address <= in_data.operand_values(4).out_value;
	mem_in_data.data <= in_data.mem_data;
	mem_in_data.instruction <= in_data.func_control.mem_control.instruction;
	mem_in_data.reg_value <= in_data.operand_values(5).out_value;
	out_control.mem_busy <= mem_out_control.mem_busy;
	out_control.mem_done <= mem_out_control.mem_done;
	out_control.mem_load <= mem_out_control.mem_load;
	out_control.read <= mem_out_control.rd;
	out_control.write <= mem_out_control.wr;
	out_control.mem_reg <= mem_out_data.mem_reg;
	out_data.mem_address <= mem_out_data.address;
	out_data.mem_data <= mem_out_data.data;
	wsu_in_data(3) <= mem_out_data.wsu_data;
	
end architecture RTL;
