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
-- Generated on "12/20/2020 16:35:00"
                                                            
-- Vhdl Test Bench template for design  :  UART
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY UART_vhd_tst IS
END UART_vhd_tst;
ARCHITECTURE UART_arch OF UART_vhd_tst IS
	-- constants     
	constant C_CLK_PERIOD : time := 20 ns;
	constant CLK_FREQUENCY : integer := 50000000;
	constant BR : integer := 38400;
	constant Rx_BIT_DURATION : time := C_CLK_PERIOD * CLK_FREQUENCY / BR;                                               
	                                            
	-- signals                                                   
	SIGNAL clock : STD_LOGIC := '1';
	SIGNAL data_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data_in_ack : STD_LOGIC := '0';
	SIGNAL data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data_out_ack : STD_LOGIC := '0';
	SIGNAL reset : STD_LOGIC := '0';
	SIGNAL rx : STD_LOGIC := '1';
	SIGNAL tx : STD_LOGIC := '1';
	SIGNAL bitrate_in : STD_LOGIC_VECTOR(2 DOWNTO 0);

	COMPONENT UART
		PORT (
		clock : IN STD_LOGIC;
		data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_in_ack : IN STD_LOGIC;
		data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_out_ack : OUT STD_LOGIC;
		bitrate_in : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		reset : IN STD_LOGIC;
		rx : IN STD_LOGIC;
		tx : OUT STD_LOGIC
	);
	END COMPONENT;
BEGIN
	i1 : UART
	PORT MAP (
		clock => clock,
		data_in => data_in,
		data_in_ack => data_in_ack,
		data_out => data_out,
		data_out_ack => data_out_ack,
		bitrate_in => bitrate_in,
		reset => reset,
		rx => rx,
		tx => tx
	);

	clock <= not clock after C_CLK_PERIOD/2;
                                         
	transmit: PROCESS
	BEGIN     
		                                                    
	       	reset <= '1';
        	wait for 20 ns;
		reset <= '0';
		wait for 10 ns;
		bitrate_in <= "000";
		data_in <= "01011101";
		wait for 15 ns;
		data_in_ack <= '1';  
		wait for Rx_BIT_DURATION*10;
		data_in_ack <= '0'; 
		WAIT;                                                        
	END PROCESS transmit;

	receive: PROCESS                                               
	BEGIN                                                         
		wait for 1000 ns;
		reset <= '1';
        	wait for 40 ns;
		reset <= '0';
		wait for 55 ns;
		--A
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION*5;
		--ENTER/CR
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for 5*Rx_BIT_DURATION;
		--A stop bit wrong
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION*5;
		--ENTER/CR
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '0';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		wait for Rx_BIT_DURATION;
		rx <= '1';
		WAIT;                                                        
	END PROCESS receive;                                          
END UART_arch;
