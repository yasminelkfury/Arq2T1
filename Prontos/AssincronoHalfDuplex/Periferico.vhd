library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity Periferico is
	port
	(
		clock: 			in STD_LOGIC;
		reset: 			in STD_LOGIC;
		
		-- Dado para comunicacao bidirecional
		data: 			inout STD_LOGIC_VECTOR(7 downto 0);
		
		-- Interface com a interface de comunicacao
		send_in_IPER:	in STD_LOGIC;
		send_out_IPER: out STD_LOGIC;
		ack_in_IPER: 	in STD_LOGIC
	);
end Periferico;

architecture Periferico of Periferico is
	
	signal dado: 		STD_LOGIC_VECTOR(7 downto 0);
	signal contador: 	STD_LOGIC_VECTOR(15 downto 0);

begin
	
	Recepcao: process(clock, reset)
	begin
		
		if reset = '1' then
		
			contador <= (others=>'0');
			dado <= (others=>'Z');
			send_out_IPER <= '0';
		
		elsif falling_edge(clock)  then
			
			-- OBS.: O sinal send deve ficar apenas um ciclo em '1'
			if send_in_IPER = '1' then
			
				dado <= data;
				contador <= contador + 1;
			
			end if;
		end if;
	end process;
end Periferico;
