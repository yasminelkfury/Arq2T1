library IEEE;
use IEEE.std_logic_1164.all;

package definicoesTransmissaoAssincrona is
	type ESTADO_TRANSMISSAO is (esperaDados, esperaAck, esperaFimAck);
end definicoesTransmissaoAssincrona;

package definicoesRecepcaoAssincrona is
	type ESTADO_RECEPCAO is (receberDados, receberFim);
end definicoesRecepcaoAssincrona;

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.definicoesTransmissaoAssincrona.all;
use work.definicoesRecepcaoAssincrona.all;

entity InterfaceCPU is
	port
	(
		clock: 			in STD_LOGIC;
		reset: 			in STD_LOGIC;
		
		data : 			inout STD_LOGIC_VECTOR(7 downto 0);
		
		-- Interface de comunicacao assincrona com a interface do periférico
		send_out_IPER: out STD_LOGIC;
		send_in_IPER: 	in STD_LOGIC;
		ack_in_IPER: 	in STD_LOGIC;
		ack_out_IPER: 	out STD_LOGIC;
		
		-- Interface com o CPU
		send_in_CPU: 	in STD_LOGIC;
		send_out_CPU: 	out STD_LOGIC;
		ack_out_CPU: 	out STD_LOGIC		
	);
end InterfaceCPU;

architecture InterfaceCPU of InterfaceCPU is

	signal estadoTx: 	ESTADO_TRANSMISSAO;
	signal estadoRx: 	ESTADO_RECEPCAO;
	signal regData: 	STD_LOGIC_VECTOR(7 downto 0);
	
begin
	
	data <= regData;

	Transmissao: process(clock, reset)
	begin
		if reset = '1' then
		
			estadoTx <= esperaDados;
			ack_out_CPU <= '0';
   	 	send_out_IPER <= '0';
			regData <= (others=>'Z');
			
		elsif rising_edge(clock) then
			
			case estadoTx is
				
				when esperaDados =>

					ack_out_CPU <= '0';
					
					if send_in_CPU = '1' then
					
						regData <= data;
						send_out_IPER <= '1';
						estadoTx <= esperaAck;
					
					end if;

				when esperaAck =>
					
					if ack_in_IPER = '1' then
						
						estadoTx <= esperaFimAck;
						send_out_IPER <= '0';
					
					end if;

				when esperaFimAck =>
					
					if ack_in_IPER = '0' then
						
						ack_out_CPU <= '1';
						estadoTx <= esperaDados;
						
					end if;

				when others => null;
			end case;
		end if;
	end process;
	
	Recepcao: process(clock, reset)
	begin
		if reset = '1' then
		
			send_out_CPU <= '0';
			ack_out_IPER <= '0';
			
		elsif rising_edge(clock) then
				
				case estadoRx is
				
					when receberDados =>
						
						if send_in_IPER = '1' then
							
							regData <= data;
							ack_out_IPER <= '1';
							send_out_CPU <= '1';
							estadoRx <= receberFim;
							
						end if;
						
					when receberFim =>
							
						if send_in_IPER = '0' then
						
							ack_out_IPER <= '0';
							send_out_CPU <= '0';
							estadoRx <= receberDados;
						
						end if;
					when others => null;
				end case;
		end if;
  end process;
end InterfaceCPU;
