library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity InterfacePeriferico is
	port
	(
		clock: in STD_LOGIC;
		reset: in STD_LOGIC;
		-- Interface de comunicacao assincrona 
		receive: in STD_LOGIC;
		--accept: out STD_LOGIC;
		dataIn: in STD_LOGIC_VECTOR(7 downto 0);
		-- Interface com a maquina local
		dadoParaMaq: out STD_LOGIC_VECTOR(7 downto 0);
		dadoRecebido: out STD_LOGIC
	);
end InterfacePeriferico;

architecture InterfacePeriferico of InterfacePeriferico is
	signal regDataIn: STD_LOGIC_VECTOR(7 downto 0);
begin
	dadoParaMaq <= regDataIn;
	Recepcao: process(clock, reset)
	begin
		if reset = '1' then
			dadoRecebido <= '0';
			regDataIn <= "00000000";
			--accept <= '0';
			
		elsif clock'event and clock = '1' then
			if (receive = '0') then
				regDataIn <= dataIn;
				dadoRecebido <= '1';
			else
				dadoRecebido <= '0';
			end if;
		end if;
  end process;
end InterfacePeriferico;
