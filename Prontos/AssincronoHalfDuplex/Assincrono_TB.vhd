library ieee;
use ieee.std_logic_1164.all;

entity tbAssincrono is
end tbAssincrono;

architecture tbAssincrono of tbAssincrono is

	signal data: std_logic_vector(7 downto 0);

-- Sinais da CPU e interface do CPU OKAY
	signal clockCPU: std_logic;
	signal resetCPU: std_logic;

-- Sinais entre CPU e interface do CPU OKAY
	signal prontoParaProximoDadoCPU: std_logic;
	signal transmitirDadoCPU: std_logic;
	signal dadoRecebidoPER: std_logic;

-- Sinais entre interfaces
 	signal transmitir_in, transmitir_out: std_logic;
	signal acknowledge_in, acknowledge_out: std_logic;

-- Sinais do Periferico e interface do PER OKAY
	signal clockPeriferico: std_logic;
	signal resetPeriferico: std_logic;

-- Sinais entre Periferico e interface local OKAY
	signal prontoParaProximoDadoPER: std_logic;
	signal transmitirDadoPER: std_logic;
	signal dadoRecebidoCPU: std_logic;

begin

	resetCPU <= '1', '0' after 100ns;
	process
	begin
		clockCPU <= '0', '1' after 8 ns;
		wait for 16 ns;
	end process;

	MaquinaCPU: entity work.CPU port map
	(
		clock => clockCPU,
		reset => resetCPU,
		
		data => data,
		
		send_out_ICPU => transmitirDadoCPU,
		ack_in_ICPU => prontoParaproximodadoCPU,
		send_in_ICPU => dadoRecebidoPER
	);
	InterfaceCPU: entity work.InterfaceCPU port map
	(
		clock => clockCPU,
		reset => resetCPU,
		
		data => data,
		
		send_out_CPU => dadoRecebidoPER,
		send_in_CPU => transmitirDadoCPU,
		ack_out_CPU => prontoParaProximoDadoCPU,
		
		send_in_IPER => transmitir_in,
		send_out_IPER => transmitir_out,
		ack_in_IPER => acknowledge_in,
		ack_out_IPER => acknowledge_out
	);

	resetPeriferico <= '1', '0' after 100ns;
	process
	begin
		clockPeriferico <= '0', '1' after 25 ns;
		wait for 50 ns;
	end process;

	MaquinaPeriferico: entity work.Periferico port map
	(
		clock => clockPeriferico,
		reset => resetPeriferico,
		
		data => data,
		
		send_in_IPER => dadoRecebidoCPU,
		send_out_IPER => transmitirDadoPER,
		ack_in_IPER => prontoParaProximoDadoPER
	);
	InterfacePeriferico: entity work.InterfacePeriferico port map
	(
		clock => clockPeriferico,
		reset => resetPeriferico,
		
		data => data,
		
		send_in_ICPU => transmitir_out,
		send_out_ICPU => transmitir_in,
		ack_in_ICPU => acknowledge_out,
		ack_out_ICPU => acknowledge_in,
		
		send_in_PER => transmitirDadoPER,
		send_out_PER => dadoRecebidoCPU,
		ack_out_PER => prontoParaProximoDadoPER
	);
end tbAssincrono;
