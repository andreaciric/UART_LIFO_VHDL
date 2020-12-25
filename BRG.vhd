----------------------------------------------------------------------------------
-- Project Name: Bit Rate Generator
--
-- Author: Andrea Ćirić
--
-- Description: 
--
-- Gets three input logic values (bit0, bit1, bit2) and depending on them, 
-- it generates a three-bit output (bitrate) that goes to the uart component 
-- that generates a bitrate (bit/s) value
-- 
-- 
-- Inputs/Outputs:
--
--    clock               - system clock
--                       
--    bit0, bit1, bit2    - input values that generate bitrate value
--
--    bitrate             - output array generated from input bitX values
--    change_ack          - 1 if there is a change, otherwise it's 0
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity BRG is
port(
	clock       : in std_logic;
    
	bit0    : in std_logic;
	bit1    : in std_logic;
    bit2    : in std_logic;
    
    bitrate     : out std_logic_vector(2 downto 0) := (others => '1');
    change_ack  : out std_logic := '0'
	);
end BRG;

architecture Behavioral of BRG is 
    signal cmp      : std_logic_vector(2 downto 0) := (others => '1');
    signal vector   : std_logic_vector(2 downto 0) := (others => '1');
begin
  
  CHANGE_BITRATE: process(clock, bit0, bit1, bit2)
	begin
        vector(0) <= bit0;
        vector(1) <= bit1;
        vector(2) <= bit2;
        if rising_edge(clock) then
            if (not (vector = cmp)) then
                bitrate <= vector;
                cmp <= vector;
                change_ack <= '1';
            else
                change_ack <= '0';
            end if;
        end if;
	end process CHANGE_BITRATE;
    
end architecture Behavioral;