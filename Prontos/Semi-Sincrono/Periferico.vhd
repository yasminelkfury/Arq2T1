library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity Periferico is
	port
	(
		clock: in STD_LOGIC;
		reset: in STD_LOGIC;
		-- Interface com a interface de comunicacao
		dadoDaInterface: in STD_LOGIC_VECTOR(7 downto 0);
		dadoRecebido: in STD_LOGIC
	);
end Periferico;

architecture Periferico of Periferico is
	signal dado: STD_LOGIC_VECTOR(7 downto 0);
	--signal contador: STD_LOGIC_VECTOR(15 downto 0);
begin
	Recepcao: process(clock, reset)
	begin
		if reset = '1' then
			--contador <= (others=>'0');
			dado <= "00000000";
		elsif clock'event and clock = '1'  then
-- OBS.: O sinal dadoRecebido deve ficar apenas um ciclo em '1'
			if dadoRecebido = '1' then
				dado <= dadoDaInterface;
				--contador <= contador + 1;
			end if;
		end if;
	end process;
end Periferico;
