library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.vlsi_pkg.all;

--	Ovo je samo psw registar. Znaci samo registar.
entity psw_register is
	port (
		clk: in std_logic;
		rst: in std_logic;
		write: in std_logic;
		in_value: in psw_register_t;
		out_value: out psw_register_t
	);
end entity psw_register;

architecture RTL of psw_register is
	signal psw_cur, psw_next: psw_register_t;
begin
	process (clk, rst) is
	begin
		if rst = '1' then
			psw_cur <= (others => '0');
		elsif rising_edge(clk) then
			psw_cur <= psw_next;
		end if;
	end process;
	
--	upis u registar samo ako je write aktivno.
	write_proc : process (in_value, psw_cur, write) is
	begin
		psw_next <= psw_cur;
		if (write = '1') then
			psw_next <= in_value;
		end if;
	end process write_proc;
	
--	vrednost psw registar je uvek na izlaznim linijama.
	out_value <= psw_cur;
	
end architecture RTL;
