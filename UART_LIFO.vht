-- Copyright (C) 2019  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "12/23/2020 01:02:20"
                                                            
-- Vhdl Test Bench template for design  :  UART_LIFO
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY UART_LIFO_vhd_tst IS
END UART_LIFO_vhd_tst;
ARCHITECTURE UART_LIFO_arch OF UART_LIFO_vhd_tst IS
	-- constants 
	constant C_CLK_PERIOD : time := 20 ps;                                                 
	-- signals                                                   
	SIGNAL bitrate_bit0 : STD_LOGIC;
	SIGNAL bitrate_bit1 : STD_LOGIC;
	SIGNAL bitrate_bit2 : STD_LOGIC;
	SIGNAL clock : STD_LOGIC := '1';
	SIGNAL data_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data_in_ack : STD_LOGIC;
	SIGNAL data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL error : STD_LOGIC;
	SIGNAL reset : STD_LOGIC := '0';

	COMPONENT UART_LIFO
	PORT (
		bitrate_bit0 : IN STD_LOGIC;
		bitrate_bit1 : IN STD_LOGIC;
		bitrate_bit2 : IN STD_LOGIC;
		clock : IN STD_LOGIC;
		data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_in_ack : IN STD_LOGIC;
		data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		error : OUT STD_LOGIC;
		reset : IN STD_LOGIC
	);
	END COMPONENT;
BEGIN
	i1 : UART_LIFO
	PORT MAP (
		-- list connections between master ports and signals
		bitrate_bit0 => bitrate_bit0,
		bitrate_bit1 => bitrate_bit1,
		bitrate_bit2 => bitrate_bit2,
		clock => clock,
		data_in => data_in,
		data_in_ack => data_in_ack,
		data_out => data_out,
		error => error,
		reset => reset
	);

	clock <= not clock after C_CLK_PERIOD/2;

	always : PROCESS                                              
	-- optional sensitivity list                                  
	-- (        )                                                 
	-- variable declarations                                      
	BEGIN                                                         
		bitrate_bit2 <= '0';
		bitrate_bit1 <= '1';
		bitrate_bit0 <= '1';	
		wait for 5 ns;        
		
		data_in <= "00000001";
		data_in_ack <= '1';
		wait for 150 ns;
		data_in_ack <= '0';
		wait for 1 us;
		data_in <= "00000010";
		data_in_ack <= '1';
		wait for 150 ns;
		data_in_ack <= '0';
		wait for 1 us;
		data_in <= "00000100";
		data_in_ack <= '1';
		wait for 150 ns;
		data_in_ack <= '0';
		wait for 1 us;
		data_in <= "00001000";
		data_in_ack <= '1';
		wait for 150 ns;
		data_in_ack <= '0';
		wait for 1 us;
		data_in <= "00010000";
		data_in_ack <= '1';
		wait for 150 ns;
		data_in_ack <= '0';
		wait for 1 us;
		data_in <= "00100000";
		data_in_ack <= '1';
		wait for 150 ns;
		data_in_ack <= '0';
		wait for 1 us;
		data_in <= "01000000";
		data_in_ack <= '1';
		wait for 150 ns;
		data_in_ack <= '0';
		wait for 1 us;
		data_in <= "10000000";
		data_in_ack <= '1';
		wait for 150 ns;
		data_in_ack <= '0';
		wait for 1 us;
		data_in <= "00001101";
		data_in_ack <= '1';
		wait for 150 ns;
		data_in_ack <= '0';
		wait for 0.5 us;
		--data_in_ack <= '0';

		WAIT;                                                        
	END PROCESS always;                                          
END UART_LIFO_arch;
