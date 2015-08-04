library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity middle is
	port(
		clk         : in  std_logic;
		rst         : in  std_logic;
		in_data     : in  middle_in_data_t;
		in_control  : in  middle_in_control_t;
		out_data    : out middle_out_data_t;
		out_control : out middle_out_control_t
	);
end entity middle;

architecture RTL of middle is

--	haz_det signals
	signal haz_in_data     : haz_detector_in_data_t;
	signal haz_in_control  : haz_detector_in_control_t;
	signal haz_out_control : haz_detector_out_control_t;

--	SM signals
	signal stall_in_control  : stall_generator_in_control_t;
	signal stall_out_control : stall_generator_out_control_t;

--	switch signals
	signal switch_in_data    : switch_in_data_t;
	signal switch_in_control : switch_in_control_t;
	signal switch_out_data   : switch_out_data_t;

--	gpr signals
	signal gpr_in_data  : gpr_in_data_t;
	signal gpr_out_data : gpr_out_data_t;

--	jzp signals
	type jzp_array_in_data_t is array(0 to GPR_READ_LINES_NUM - 1) of jzp_in_data_t;
	signal jzp_in_data : jzp_array_in_data_t;

--	stopko stignals
	signal stopko_in_data : stopko_in_data_t;
	signal stopko_in_control : stopko_in_control_t;
	signal stopko_out_control : stopko_out_control_t;
	
begin
	haz_d : entity work.hazard_detector
		port map(
			in_data     => haz_in_data,
			in_control  => haz_in_control,
			out_control => haz_out_control
		);

	haz_in_data.instructions  <= in_data.from_id.instructions;
	haz_in_control.inst_ready <= stall_out_control.inst_ready;
	haz_in_control.mem_busy   <= in_control.mem_busy;
	haz_in_control.mem_load   <= in_control.mem_load;
	haz_in_control.mem_reg    <= in_control.mem_reg;

	stall_g : entity work.stall_generator
		port map(
			clk         => clk,
			rst         => rst,
			in_control  => stall_in_control,
			out_control => stall_out_control
		);

	stall_in_control.haz_type <= haz_out_control.haz_type;
	stall_in_control.mem_done <= in_control.mem_done;
--	stall je logicko ILI signala stall iz stall_generatora i stopka
--	out_control.stall         <= stall_out_control.stall;

	sw : entity work.switch
		port map(
			data_in    => switch_in_data,
			control_in => switch_in_control,
			data_out   => switch_out_data
		);

	switch_in_data.instructions <= in_data.from_id.instructions;
	switch_in_control.inst_go   <= stall_out_control.inst_go;
	out_data.func_control       <= switch_out_data.func_control;

	gpr : entity work.gpr_file
		port map(
			clk      => clk,
			rst      => rst,
			in_data  => gpr_in_data,
			out_data => gpr_out_data
		);

	gpr_in_data.write_data_arr  <= in_data.from_wsu;
	--	Fica cita r1 i r2 iz gpr
	gpr_in_data.read_address(0) <= in_data.from_id.instructions(0).r1;
	gpr_in_data.read_address(1) <= in_data.from_id.instructions(0).r2;
	--	Fedja cita r1 i r2 iz gpr	
	gpr_in_data.read_address(2) <= in_data.from_id.instructions(1).r1;
	gpr_in_data.read_address(3) <= in_data.from_id.instructions(1).r2;
	--	Switch cita iz gpr	
	gpr_in_data.read_address(4) <= switch_out_data.r1;
	gpr_in_data.read_address(5) <= switch_out_data.r3;


--	ovaj deo koda generise 6 JZP entiteta. 
--	out_data.operand_values je niz duzine 6.
--	Ovaj niz sadrzi vrednosti prosledjene iz jzp, tj. sadrzi operande za func jedinice.
--	element 0 u nizu je r1 prve instrukcije, zatim sledi r2 prve instrukcije.
--	r1 i r2 druge instrukcije zauzimaju indexe 2 i 3, respektivno. :)
--	na indexima 4 i 5 su r1 i r3 MEM instrukcije.

	jzp_for : for i in 0 to GPR_READ_LINES_NUM - 1 generate
		jzp_inst : entity work.jzp
			port map(
				in_data  => jzp_in_data(i),
				out_data => out_data.operand_values(i)
			);
		
		jzp_in_data(i).from_gpr <= gpr_out_data.value(i);
		jzp_in_data(i).from_wsu <= in_data.from_wsu;
		jzp_in_data(i).address <= gpr_in_data.read_address(i);
	end generate jzp_for;
	
	
	stopko : entity work.stopko_unit
		port map(
			clk         => clk,
			rst         => rst,
			in_data     => stopko_in_data,
			in_control  => stopko_in_control,
			out_control => stopko_out_control
		);
		
	stopko_in_data.instructions(0).op <= in_data.from_id.instructions(0).op;
	stopko_in_data.instructions(0).valid <= in_data.from_id.instructions(0).valid;
	stopko_in_data.instructions(1).op <= in_data.from_id.instructions(1).op;
	stopko_in_data.instructions(1).valid <= in_data.from_id.instructions(1).valid;
			
	stopko_in_control.mem_busy <= in_control.mem_busy;
	out_control.stop <= stopko_out_control.stop;
	out_control.stall <= stopko_out_control.stall or stall_out_control.stall;
	
end architecture RTL;
