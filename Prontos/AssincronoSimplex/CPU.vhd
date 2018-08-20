library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity CPU is
	port
	(
		clock: in STD_LOGIC;
		reset: in STD_LOGIC;
		-- Interface com a interface de comunicacao
		dadoParaInterface: out STD_LOGIC_VECTOR(7 downto 0);
		prontoParaProximoDado: in STD_LOGIC;
		transmitirDado: out STD_LOGIC
	);
end CPU;

architecture CPU of CPU is
	signal dado: STD_LOGIC_VECTOR(7 downto 0);
	signal contador: STD_LOGIC_VECTOR(15 downto 0);
begin
	dadoParaInterface <= dado;
	Transmissao: process(clock, reset)
	begin
		if reset = '1' then
			dado <= x"00";
			transmitirDado <= '1';
			contador <= (others=>'0');
		elsif clock'event and clock = '1' then
			if prontoParaProximoDado = '1' and contador < 20 then
				dado <= dado + 1;
				contador <= contador + 1;
				transmitirDado <= '1';
			else
				transmitirDado <= '0';
			end if;
		end if;
	end process;
end CPU;
