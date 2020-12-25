----------------------------------------------------------------------------------
-- Project Name: UART
--
-- Author: Andrea Ćirić
--
-- Description: 
--
-- Implements a universal asynchronous receiver-transmitter.
--
-- Data: Start bit value 0, 8 data bits and stop bit value 1
-- 
-- Bit rate values:
--      "000" => bit rate = 1200 bits/s;
--      "001" => bit rate = 2400 bits/s; 
--      "010" => bit rate = 4800 bits/s; 
--      "011" => bit rate = 9600 bits/s; 
--      "100" => bit rate = 19200 bits/s; 
--      "101" => bit rate = 38400 bits/s; 
--      "110" => bit rate = 57600 bits/s;
--      "111" => bit rate = 115200 bits/s;
-- 
-- Inputs/Outputs:
--
--   General:
--		reset           - reset signal
--		clock           - system clock 50MHz
--                       
--   Bit rate:
--      bitrate_in      - input array that generates bit rate value
--
--   Transmitter:
--		data_in         - input 8 bit data to transmit
--      data_in_ack     - input signal that says data is in and ready to transmit
--      tx              - serial data output
--
--   Receiver:
--      data_out        - output 8bit received data
--      data_out_ack    - output signal that data is received
--      rx              - serial data input
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity UART is
    generic (
        clock_frequency     : positive := 50000000      
    );
    port(
        --general
		reset           : in std_logic;
		clock           : in std_logic;
        
        --bitrate
        bitrate_in      : in std_logic_vector(2 downto 0);
        
        --transmitter
        data_in         :   in  std_logic_vector(7 downto 0);
        data_in_ack     :   in std_logic;
        tx              :   out std_logic;
        
        --receiver
        data_out        :   out std_logic_vector(7 downto 0);
        data_out_ack    :   out std_logic;
        rx              :   in  std_logic
	);
end UART;

architecture Behavioral of UART is

    --Transmitter signals
	type State_tx is (stStartBitTx, stDataTx, stStopBitTx);
	signal state_reg_tx: State_tx;
    
    signal bitrate : integer := 1200;
    signal bitrate_buffer : integer := 1200;
    signal sample_Tx  : integer := clock_frequency / bitrate;
    constant baud_counter_Tx_width : integer := integer(log2(real(sample_Tx))) + 1;  
    signal baud_counter_Tx : unsigned(baud_counter_Tx_width - 1 downto 0) := (others => '0');   
    signal write_signal : std_logic := '0';

    signal data_Tx : std_logic := '1';
    signal data_Tx_vector : std_logic_vector(7 downto 0) := (others => '0');
    signal data_Tx_ack : std_logic := '0';
    signal counter_Tx : unsigned(2 downto 0) := (others => '0');

    --Receiver signals
    type State_rx is (stIdleRx,stStartBitRx, stDataRx, stStopBitRx);
	signal state_reg_rx: State_rx;
    
    signal sample_Rx : integer := clock_frequency / (16 * bitrate);
    constant baud_counter_Rx_width : integer := integer(log2(real(sample_Rx))) + 1;  
    signal baud_counter_Rx : unsigned(baud_counter_Rx_width - 1 downto 0) := (others => '0');   
    signal sample : std_logic := '0';
    signal read_counter : unsigned (3 downto 0) := (others => '0');
    signal read_signal : std_logic := '0';
    
    signal data_Rx_vector : std_logic_vector(7 downto 0) := (others => '0');
    signal data_Rx_ack : std_logic := '0';
    signal counter_Rx : unsigned(3 downto 0) := (others => '0');
    signal data_out_buffer : std_logic_vector(7 downto 0) := (others => '0');
    
    signal provera : unsigned(16 downto 0) := (others => '0');
    signal proveraRx : std_logic;
    
begin
    
    tx <= data_Tx;
    data_out_ack <= data_Rx_ack;
    data_out <= data_out_buffer;
    
  ----------------------------------------------------------------------------
  -- BIT_RATE_GENERATE
  -- Bit rate selection
  ----------------------------------------------------------------------------
  BIT_RATE_GENERATE: process (reset, clock)
    begin
        if rising_edge(clock) then
            case bitrate_in is
                when "000" => bitrate <= 1200;
                when "001" => bitrate <= 2400; 
                when "010" => bitrate <= 4800; 
                when "011" => bitrate <= 9600; 
                when "100" => bitrate <= 19200; 
                when "101" => bitrate <= 38400; 
                when "110" => bitrate <= 57600;
                when "111" => bitrate <= 115200;
                when others => bitrate <= 9600;
            end case;
            sample_Tx <= clock_frequency / bitrate;
            sample_Rx <= clock_frequency / (16 * bitrate);
            if not (bitrate_buffer = bitrate) then
                bitrate_buffer <= bitrate;
            end if;
        end if;
   end process BIT_RATE_GENERATE;
  
  ---------------------------------------------------------------------------
  -- TRANSMITTER_CLK
  -- Generates write signal at the required rate based on the input clock
  -- frequency and bit rate. Tx and Rx must have the same bit rate.
  ---------------------------------------------------------------------------  
  TRANSMITTER_CLK : process (clock)
    begin
        if rising_edge (clock) then
            if reset = '1' or (not (bitrate_buffer = bitrate)) then
                baud_counter_Tx <= (others => '0');
                write_signal <= '0'; 
                provera <= (others => '0');
            else
                if baud_counter_Tx = sample_Tx - 1 then          
                    baud_counter_Tx <= (others => '0');
                    write_signal <= '1';
                    provera <= provera + 1;
                else
                    baud_counter_Tx <= baud_counter_Tx + 1;
                    write_signal <= '0';
                end if;
            end if;
        end if;
    end process TRANSMITTER_CLK;
 
  ---------------------------------------------------------------------------
  -- TRANSMIT 
  -- Gets data from data_in and sends it one bit at a time upon each write signal. 
  -- Sends data least significant bit first.
  -- Sends start bit (0), then data 0-7, then stop bit (1) to tx (tx <= data_Tx)
  --------------------------------------------------------------------------- 
  TRANSMIT : process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                data_Tx <= '1';
                data_Tx_vector <= (others => '0');
                counter_Tx <= (others => '0');
                state_reg_tx <= stStartBitTx;
                data_Tx_ack <= '0';
            else
                case state_reg_tx is
                    when stStartBitTx =>
                        if (write_signal = '1' and data_in_ack = '1') then
                            data_Tx  <= '0';
                            state_reg_tx <= stDataTx;
                            counter_Tx <= (others => '0');
                            data_Tx_vector <= data_in;
                        end if;
                    when stDataTx =>
                        if (write_signal = '1') then
                            data_Tx <= data_Tx_vector(0);
                            data_Tx_vector(6 downto 0) <= data_Tx_vector(7 downto 1);
                            
                            if (counter_Tx < 7) then
                                counter_Tx <= counter_Tx + 1;
                            else
                                counter_Tx <= (others => '0');
                                state_reg_tx <= stStopBitTx;
                            end if;
                        end if;
                    when stStopBitTx =>
                        if (write_signal = '1') then
                            data_Tx <= '1';
                            state_reg_tx <= stStartBitTx;
                        end if;
                    when others =>
                        data_Tx <= '1';
                        state_reg_tx <= stStartBitTx;
                end case;
            end if;
        end if;
    end process TRANSMIT;
 
  ---------------------------------------------------------------------------
  -- RECEIVER_CLK
  -- generates sampling signal (bitrate * 16)
  --------------------------------------------------------------------------- 
  RECEIVER_CLK : process (clock)
    begin
        if rising_edge (clock) then
            if reset = '1' then
                baud_counter_Rx <= (others => '0');
                sample <= '0';    
            else
                if baud_counter_Rx = sample_Rx - 1 then
                    baud_counter_Rx <= (others => '0');
                    sample <= '1';
                else
                    baud_counter_Rx <= baud_counter_Rx + 1;
                    sample <= '0';
                end if;
            end if;
        end if;
    end process RECEIVER_CLK;

  ---------------------------------------------------------------------------
  -- GENERATE_READ
  -- generates read signal in the middle (read_counter = 7 in range [0,15]) to be sure
  -- to "catch" every value
  ---------------------------------------------------------------------------    
   GENERATE_READ : process (clock)
    begin
        if rising_edge(clock) then
            read_signal <= '0';
            if sample = '1' then       
                if read_counter = 15 then
                    read_signal <= '0';
                    read_counter <= (others => '0');
                else
                    read_counter <= read_counter + 1;
                    if (read_counter = 7) then
                        read_signal <= '1';
                    else 
                        read_signal <= '0';
                    end if;
                end if;
                if state_reg_rx = stIdleRx then
                    read_counter <= (others => '0');
                end if; 
            end if;
        end if;
    end process GENERATE_READ;
 
  ---------------------------------------------------------------------------
  -- RECEIVE
  -- Waits for start bit (first 0 value) then reads next 8 bits (data bits)
  -- then if the stop bit is okay (1) gets loaded data to 8-bit data_out
  ---------------------------------------------------------------------------   
  RECEIVE : process(clock)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                state_reg_rx <= stIdleRx;
                data_Rx_vector <= (others => '0');
                counter_Rx <= (others => '0');
                data_Rx_ack <= '0';
            else
                data_Rx_ack <= '0';
                case state_reg_rx is
                    when stIdleRx =>
                        if sample = '1' and rx = '0' then
                            state_reg_rx <= stStartBitRx;
                            proveraRx <= '0';
                        end if;
                    when stStartBitRx =>
                        if read_signal = '1' and rx = '0' then
                            state_reg_rx <= stDataRx;
                        end if;
                    when stDataRx =>
                        if read_signal = '1' then
                            data_Rx_vector(7) <= rx;
                            data_Rx_vector(6 downto 0) <= data_Rx_vector(7 downto 1);
                            if counter_Rx < 7  then
                                counter_Rx   <= counter_Rx + 1;
                            else
                                counter_Rx <= (others => '0');
                                state_reg_rx <= stStopBitRx;
                            end if;
                        end if;
                    when stStopBitRx =>
                        if read_signal = '1' then
                            if rx = '1' then
                                proveraRx <= '1';
                                data_out_buffer <= data_Rx_vector;
                                data_Rx_ack <= '1';
                            end if;
                            state_reg_rx <= stIdleRx;
                        end if;                            
                    when others =>
                        state_reg_rx <= stIdleRx;
                end case;
            end if;
        end if;
    end process RECEIVE;
    
    
end architecture Behavioral;