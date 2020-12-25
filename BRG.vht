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
-- Generated on "12/23/2020 01:12:30"
                                                            
-- Vhdl Test Bench template for design  :  BRG
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY BRG_vhd_tst IS
END BRG_vhd_tst;
ARCHITECTURE BRG_arch OF BRG_vhd_tst IS
	-- constants 
	constant C_CLK_PERIOD : time := 20 ps;                                                
	-- signals                                                   
	SIGNAL bit0 : STD_LOGIC;
	SIGNAL bit1 : STD_LOGIC;
	SIGNAL bit2 : STD_LOGIC;
	SIGNAL bitrate : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL change_ack : STD_LOGIC;
	SIGNAL clock : STD_LOGIC := '1';

	COMPONENT BRG
		PORT (
			bit0 : IN STD_LOGIC;
			bit1 : IN STD_LOGIC;
			bit2 : IN STD_LOGIC;
			bitrate : BUFFER STD_LOGIC_VECTOR(2 DOWNTO 0);
			change_ack : BUFFER STD_LOGIC;
			clock : IN STD_LOGIC
		);
	END COMPONENT;
BEGIN
	i1 : BRG
	PORT MAP (
		-- list connections between master ports and signals
		bit0 => bit0,
		bit1 => bit1,
		bit2 => bit2,
		bitrate => bitrate,
		change_ack => change_ack,
		clock => clock
	);

	clock <= not clock after C_CLK_PERIOD/2;
                                          
	always : PROCESS                                              
		-- optional sensitivity list                                  
		-- (        )                                                 
		-- variable declarations                                      
	BEGIN                                                         
		wait for 40 ps;
		bit0 <= '0';
		bit1 <= '0';
		bit2 <= '0';
		wait for 30 ps;
		bit2 <= '1';
		wait for 67 ps;
		bit1 <= '1';
		wait for 73 ps;
		bit2 <= '0';	
		wait for 30 ps;
		bit0 <= '1';

		WAIT;                                                        
	END PROCESS always;                                          
END BRG_arch;
