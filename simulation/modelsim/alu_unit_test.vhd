library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

entity alu_unit_test is
end entity alu_unit_test;

architecture test_arch of alu_unit_test is
	component alu_unit
		port(clk        : in  std_logic;
			 rst        : in  std_logic;
			 in_control : in  alu_in_control_t;
			 in_data    : in  alu_in_data_t;
			 out_data   : out alu_out_data_t);
	end component alu_unit;

	signal clk        : std_logic;
	signal rst        : std_logic;
	signal in_control : alu_in_control_t;
	signal in_data    : alu_in_data_t;
	signal out_data   : alu_out_data_t;

begin

	-- clock driver process
	clock_driver : process
		constant period : time := CLK_PERIOD;
	begin
		clk <= '0';
		wait for period / 2;
		clk <= '1';
		wait for period / 2;
	end process clock_driver;

	dut : component alu_unit
		port map(
			clk        => clk,
			rst        => rst,
			in_control => in_control,
			in_data    => in_data,
			out_data   => out_data
		);

	stim_proc : process is
	begin
		rst <= '1';

		wait until rising_edge(clk);

		rst <= '0';

		-- obicni add koji bi trebao da proizvede PSW(C_FLAG)
		-- ali posto nemamo povezan psw, onda se ta vrednost vestacki podmece narednoj instrukciji
		in_control.go             <= '1';
		in_data.instruction.valid <= '1';
		in_data.instruction.op    <= ADD_M;
		in_data.instruction.r3    <= B"00111";
		in_data.instruction.pc    <= (others => '0');

		in_data.operand_A.out_value <= X"F000_0010";
		in_data.operand_B.out_value <= X"A000_000A";

		in_data.psw <= (31 => '0', 30 => '0', 29 => '0', 28 => '0', others => '0');

		wait until rising_edge(clk);

		-- ADC, proveravamo da li ispravno cita psw i da li azurira flegove
		in_control.go             <= '1';
		in_data.instruction.valid <= '1';
		in_data.instruction.op    <= ADC_M;
		in_data.instruction.r3    <= B"00111";
		in_data.instruction.pc    <= (others => '0');

		in_data.operand_A.out_value <= X"0000_0010";
		in_data.operand_B.out_value <= X"0000_000A";

		in_data.psw <= (31 => '0', 30 => '0', 29 => '1', 28 => '0', others => '0');

		wait until rising_edge(clk);

		in_control.go <= '0';
		
		wait until rising_edge(clk);
		
		-- shift left, nista specijalno
		in_control.go             <= '1';
		in_data.instruction.valid <= '1';
		in_data.instruction.op    <= SL_M;
		in_data.instruction.r3    <= B"00111";
		in_data.instruction.pc    <= (others => '0');

		in_data.operand_A.out_value <= X"0000_0003";
		in_data.operand_B.out_value <= X"0000_000A";

		in_data.psw <= (31 => '0', 30 => '0', 29 => '0', 28 => '0', others => '0');		

		wait until rising_edge(clk);
		
		-- provaravamo rad CMP instrukcije
		-- setoovanje flegova bez davanja rezultata
		in_control.go             <= '1';
		in_data.instruction.valid <= '1';
		in_data.instruction.op    <= CMP_M;
		in_data.instruction.r3    <= B"00111";
		in_data.instruction.pc    <= (others => '0');

		in_data.operand_A.out_value <= X"00A0_B17E";
		in_data.operand_B.out_value <= X"00A0_B17E";

		in_data.psw <= (31 => '0', 30 => '0', 29 => '0', 28 => '0', others => '0');		

		wait until rising_edge(clk);		

		in_control.go <= '0';

		wait;

	end process stim_proc;

end architecture test_arch;

