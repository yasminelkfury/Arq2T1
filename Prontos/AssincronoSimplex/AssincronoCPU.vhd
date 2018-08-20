library IEEE;
use IEEE.std_logic_1164.all;
package definicoesTransmissaoAssincrona is
	type ESTADO_TRANSMISSAO is (esperaDados, esperaAck, esperaFimAck, esperaFimAck2);
end definicoesTransmissaoAssincrona;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.definicoesTransmissaoAssincrona.all;

entity InterfaceCPU is
	port
	(
		clock: in STD_LOGIC;
		reset: in STD_LOGIC;
		-- Interface de comunicacao assincrona
		send: out STD_LOGIC;
		ack: in STD_LOGIC;
		dataOut : out STD_LOGIC_VECTOR(7 downto 0);
		-- Interface com a maquina local
		dadoDaMaq : in STD_LOGIC_VECTOR(7 downto 0); -- dado
		prontoParaProximoDado: out STD_LOGIC; -- ack pro CPU
		transmitirDado: in STD_LOGIC -- send CPU
	);
end InterfaceCPU;

architecture InterfaceCPU of InterfaceCPU is
	signal estadoTx: ESTADO_TRANSMISSAO;
	signal regDataOut: STD_LOGIC_VECTOR(7 downto 0);
begin
	
	dataOut <= regDataOut;

	Transmissao: process(clock, reset)
	begin
		if reset = '1' then
			estadoTx <= esperaDados;
			prontoParaProximoDado <= '0';
   	 	send <= '0';
			regDataOut <= (others=>'Z');
		elsif rising_edge(clock) then
			
			case estadoTx is
				
				when esperaDados =>

					if transmitirDado = '1' then -- Se recebi um 'send' do CPU
					
						regDataOut <= dadoDaMaq; -- recebo os dados
						send <= '1'; -- ativo o sinal de 'send' para a interface do periférico
						estadoTx <= esperaAck; -- mudo de estado
					
					end if;

				when esperaAck =>
					
					if ack = '1' then -- se a interface do periférico recebeu os dados
						estadoTx <= esperaFimAck; -- mudo de estado
						prontoParaProximoDado <= '1'; -- e aviso ao CPU que recebi os dados
						send <= '0'; -- e baixo meu sinal de 'send'
					end if;

				when esperaFimAck =>
					
					prontoParaProximoDado <= '0'; -- abaixo o sinal de 'ack' para o CPU
					if transmitirDado = '1' then
						if ack = '0' then -- se a interface do periférico abaixou o 'ack'
							regDataOut <= dadoDaMaq; -- recebo os dados
							send <= '1'; -- ativo o sinal de 'send' para a interface do periférico
							estadoTx <= esperaAck; -- mudo de estado
						else
							estadoTx <= esperaFimAck2; -- mudo de estado
						end if;
					else
						if ack = '0' then -- se a interface do periférico abaixou o 'ack'
							estadoTx <= esperaDados; -- e mudo de estado
						end if;
					end if;

				when esperaFimAck2 =>
					if ack = '0' then -- se a interface do periférico abaixou o 'ack'
						regDataOut <= dadoDaMaq; -- recebo os dados
						send <= '1'; -- ativo o sinal de 'send' para a interface do periférico
						estadoTx <= esperaAck; -- mudo de estado
					end if;

			end case;
		end if;
	end process;
end InterfaceCPU;
