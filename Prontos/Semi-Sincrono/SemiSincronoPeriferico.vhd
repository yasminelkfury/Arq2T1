library IEEE;
use IEEE.STD_LOGIC_1164.all;
package definicoesRecepcaoAssincrona is
	type ESTADO_RECEPCAO is (receberDados, esperaAck, esperaFimAck);
end definicoesRecepcaoAssincrona;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.definicoesRecepcaoAssincrona.all;

entity InterfacePeriferico is
	port
	(
		clock: in STD_LOGIC;
		reset: in STD_LOGIC;
		-- Interface de comunicacao assincrona 
		receive: in STD_LOGIC; -- send
		accept: out STD_LOGIC; -- ack
		dataIn: in STD_LOGIC_VECTOR(7 downto 0);
		-- Interface com a maquina local
		dadoParaMaq: out STD_LOGIC_VECTOR(7 downto 0);
		dadoRecebido: out STD_LOGIC
	);
end InterfacePeriferico;

architecture InterfacePeriferico of InterfacePeriferico is
	signal estadoRx: ESTADO_RECEPCAO;
	signal regDataIn: STD_LOGIC_VECTOR(7 downto 0);
begin

	dadoParaMaq <= regDataIn;

	Recepcao: process(clock, reset)
	begin
		if reset = '1' then
			dadoRecebido <= '0';
			accept <= '0';
			regDataIn <= (others=>'0');
		elsif rising_edge(clock) then
				
				case estadoRx is
				
					when receberDados =>
						
						if receive = '1' then -- Se eu recebi um 'send' do transmissor então
							
							regDataIn <= dataIn; -- guardo o dado
							accept <= '1'; -- digo que recebi
							dadoRecebido <= '1'; -- envio o dado ao periférico
							estadoRx <= esperaAck; -- e mudo para o estado de abaixar o 'ack'
							
						end if;
						
					when esperaAck => 
						
						accept <= '0'; -- abaixo o sinal de 'ack' para a interface da CPU
						dadoRecebido <= '0';
						estadoRx <= receberDados; -- e volto para o estado de esperar os dados
					
					when others => null;
				end case;
		end if;
  end process;
  
end InterfacePeriferico;
