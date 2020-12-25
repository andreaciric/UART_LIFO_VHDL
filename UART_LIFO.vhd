----------------------------------------------------------------------------------
-- Project Name: UART LIFO
--
-- Author: Andrea Ćirić
--
-- Description: 
--
-- Gets input data until input value is enter (Carriage Return = "00001101"). 
-- Values go to the uart transmitter then through serial port to the uart receiver.
-- From uart receiver output values are being stored in the LIFO memory (stack).
-- When input value is enter, stored values are written to the output 
-- in the LIFO order.
--
-- Components implemented: UART, Bit Rate Generator, LIFO MEMORY
-- 
-- 
-- Inputs/Outputs:
--
--    clock           - system clock
--    restart         - reset signal
--
--    bitrate_bit0    - input values that generate bitrate value
--    bitrate_bit1    -                 -||-
--    bitrate_bit2    -                 -||-
--
--    data_in         - input data values
--    data_in_ack     - input signal that says data is in and ready to transmit
--    data_out        - output data values
--
--    error           - output signal high if memory is full
--
----------------------------------------------------------------------------------

library ieee; 							
use ieee.std_logic_1164.all;

entity UART_LIFO is 						
	port (
    
        bitrate_bit0    : in std_logic;
        bitrate_bit1    : in std_logic;
        bitrate_bit2    : in std_logic;
        
        data_in         : in std_logic_vector(7 downto 0);
        data_in_ack     : in std_logic;
        data_out        : out std_logic_vector(7 downto 0);
        
        clock           : in std_logic;
        reset           : in std_logic;
		
        error           : out std_logic
	);
end UART_LIFO;


architecture Structural of UART_LIFO is 	

    component UART is
        generic (
            clock_frequency     : positive := 50000000      
        );
        port(
            reset           :   in std_logic;
            clock           :   in std_logic;
            bitrate_in      :   in std_logic_vector(2 downto 0);
            data_in         :   in std_logic_vector(7 downto 0);
            data_in_ack     :   in std_logic;
            tx              :   out std_logic;
            data_out        :   out std_logic_vector(7 downto 0);
            data_out_ack    :   out std_logic;
            rx              :   in  std_logic
        );
    end component;

    component LIFO_MEMORY is
        generic(
            data_size   : natural := 8;
            memory_size : natural := 256
        );
        port(
            data_in     :   in  std_logic_vector(data_size - 1 downto 0);
            data_out    :   out std_logic_vector(data_size - 1 downto 0);
            
            pop         :   in  std_logic; 
            push        :   in  std_logic;
            
            is_full     :   out std_logic;
            is_empty    :   out std_logic;
            
            clock       :   in  std_logic;
            restart     :   in  std_logic
        );
    end component;
    
    component BRG is
        port(
            clock   :   in std_logic;
    
            bit0    :   in std_logic;
            bit1    :   in std_logic;
            bit2    :   in std_logic;
    
            bitrate     :   out std_logic_vector(2 downto 0);
            change_ack  :   out std_logic
        );
    end component;
    
    
    signal tx_rx    :   std_logic;
    signal error1   :   std_logic;
    signal error2   :   std_logic;
    signal pop_temp :   std_logic := '0';
    
    signal count_chars      :   integer     := 0;
    signal stop_incoming    :   std_logic   := '0';
    signal bitrate_temp     :   std_logic_vector(2 downto 0);
    signal uart_to_memory   :   std_logic_vector(7 downto 0);
    
    signal bitrate_changed      :   std_logic;
    signal data_in_ack_temp     :   std_logic;
    signal ack_uart_to_memory   :   std_logic;
    
    signal do_pop               : std_logic := '0';
    signal pop_counter          : integer   := 0;
    signal sample_value         : integer;
    constant clock_frequency    : integer   := 50000000;
    signal bitrate_value        : integer;
    	
begin

    BITRATE_GENERATOR_COMPONENT: BRG port map (
            clock       =>  clock, 
            bit0        =>  bitrate_bit0, 
            bit1        =>  bitrate_bit1, 
            bit2        =>  bitrate_bit2,
            bitrate     =>  bitrate_temp, 
            change_ack  =>  bitrate_changed
        );

    UART_COMPONENT: UART port map(
            reset           =>  reset, 
            clock           =>  clock,
            bitrate_in      =>  bitrate_temp,
            data_in         =>  data_in,
            data_in_ack     =>  data_in_ack_temp,
            tx              =>  tx_rx,
            data_out        =>  uart_to_memory,
            data_out_ack    =>  ack_uart_to_memory,
            rx              =>  tx_rx
        );
    
    MEMORY_COMPONENT: LIFO_MEMORY port map(
        data_in     =>  uart_to_memory,
        data_out    =>  data_out,
        pop         =>  pop_temp, 
        push        =>  ack_uart_to_memory,
        is_full     =>  error1,
        is_empty    =>  error2,
        clock       =>  clock,
        restart     =>  reset
    );
    
  ----------------------------------------------------------------------------
  -- BIT_RATE_GENERATE
  -- Bit rate selection needed for generating output writing pace
  ----------------------------------------------------------------------------   
    BIT_RATE_GEN: process (reset, clock)
    begin
        if rising_edge(clock) then
            case bitrate_temp is
                when "000" => bitrate_value <= 1200;
                when "001" => bitrate_value <= 2400; 
                when "010" => bitrate_value <= 4800; 
                when "011" => bitrate_value <= 9600; 
                when "100" => bitrate_value <= 19200; 
                when "101" => bitrate_value <= 38400; 
                when "110" => bitrate_value <= 57600;
                when "111" => bitrate_value <= 115200;
                when others => bitrate_value <= 9600;
            end case;
            sample_value <= 10 * clock_frequency / bitrate_value;   -- 10 za 10 bitova (8 data + start bit + stop bit)
        end if;
   end process BIT_RATE_GEN;
    
  ----------------------------------------------------------------------------
  -- CHECK_FOR_ENTER
  -- If enter (Carriage Return) then stop writing to memory and start writing
  -- from memory to output (LIFO order) 
  ----------------------------------------------------------------------------  
    CHECK_FOR_ENTER: process (uart_to_memory, pop_temp, ack_uart_to_memory, clock, count_chars) is
    begin
        if rising_edge(clock) then
            if uart_to_memory = "00001101" then
                if count_chars > 0 then
                    stop_incoming   <= '1';
                    do_pop          <= '1';
                else
                    do_pop          <= '0';
                    stop_incoming   <= '0';
                end if;
            end if;
            if ack_uart_to_memory = '1' then
                    count_chars     <= count_chars + 1;
            end if;
            if do_pop = '1' then
                if reset = '1' then
                    pop_counter     <= 0;
                    pop_temp        <= '0'; 
                else
                    if pop_counter = sample_value - 1 then          
                        pop_counter <= 0;
                        pop_temp    <= '1';
                        count_chars <= count_chars - 1;
                    else
                        pop_counter <= pop_counter + 1;
                        pop_temp    <= '0';
                    end if;
                end if;
            end if;
        end if;
    end process CHECK_FOR_ENTER;
    
    error <= error1;
    data_in_ack_temp <= data_in_ack and (not stop_incoming);
        
end Structural;