library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_unsigned.all;

entity CPU is
	port
	(
		clock: 			in STD_LOGIC;
		reset: 			in STD_LOGIC;
		
		-- Dado para comunicacao bidirecional
		data: 			inout STD_LOGIC_VECTOR(7 downto 0);
		
		-- Interface com a interface de comunicacao
		send_out_ICPU: out STD_LOGIC;
		ack_in_ICPU: 	in STD_LOGIC;
		send_in_ICPU: 	in STD_LOGIC
	);
end CPU;

architecture CPU of CPU is

	signal dado: 		STD_LOGIC_VECTOR(7 downto 0);
	signal contador: 	STD_LOGIC_VECTOR(15 downto 0);

begin

	data <= dado when ack_in_ICPU = '1' else (others=>'Z');

	Transmissao: process(clock, reset)
	begin
		if reset = '1' then

			dado <= (others=>'0');
			send_out_ICPU <= '1';
			contador <= (others=>'0');

		elsif falling_edge(clock) then

			if ack_in_ICPU = '1' and contador < 20 then

				dado <= dado + 1;
				contador <= contador + 1;
				send_out_ICPU <= '1';

			else

				send_out_ICPU <= '0';

			end if;
		end if;
	end process;
end CPU;
