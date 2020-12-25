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
-- Generated on "12/22/2020 13:29:17"
                                                            
-- Vhdl Test Bench template for design  :  LIFO_MEMORY
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY LIFO_MEMORY_vhd_tst IS
END LIFO_MEMORY_vhd_tst;
ARCHITECTURE LIFO_MEMORY_arch OF LIFO_MEMORY_vhd_tst IS
	-- constants    
	constant C_CLK_PERIOD : time := 20 ps;                                                    
	-- signals                                                   
	SIGNAL clock : STD_LOGIC := '1';
	SIGNAL data_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL data_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL is_empty : STD_LOGIC;
	SIGNAL is_full : STD_LOGIC;
	SIGNAL pop : STD_LOGIC := '0';
	SIGNAL push : STD_LOGIC := '0';
	SIGNAL restart : STD_LOGIC := '0';
	
	COMPONENT LIFO_MEMORY
		PORT (
		clock : IN STD_LOGIC;
		data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_out : BUFFER STD_LOGIC_VECTOR(7 DOWNTO 0);
		is_empty : BUFFER STD_LOGIC;
		is_full : BUFFER STD_LOGIC;
		pop : IN STD_LOGIC;
		push : IN STD_LOGIC;
		restart : IN STD_LOGIC
	);
	END COMPONENT;
BEGIN
	i1 : LIFO_MEMORY
		PORT MAP (
		-- list connections between master ports and signals
		clock => clock,
		data_in => data_in,
		data_out => data_out,
		is_empty => is_empty,
		is_full => is_full,
		pop => pop,
		push => push,
		restart => restart
	);
	
	clock <= not clock after C_CLK_PERIOD/2;
	                                           
	always : PROCESS                                              
	-- optional sensitivity list                                  
	-- (        )                                                 
	-- variable declarations                                      
	BEGIN                                                         
	        data_in <= "00000001";
		wait for 10 ns;
		push <= '1';
		wait for C_CLK_PERIOD;
		push <= '0';
		data_in <= "00000010";
		wait for 10 ns;
		push <= '1';
		wait for C_CLK_PERIOD;
		push <= '0';
		data_in <= "00000100";
		wait for 10 ns;
		push <= '1';
		wait for C_CLK_PERIOD;
		push <= '0';
		data_in <= "00001000";
		wait for 10 ns;
		push <= '1';
		wait for C_CLK_PERIOD;
		push <= '0';
		wait for 10 ns;
		pop <= '1';
		wait for C_CLK_PERIOD;
		pop <= '0';
		wait for 10 ns;
		pop <= '1';
		wait for C_CLK_PERIOD;
		pop <= '0';
		wait for 10 ns;
		pop <= '1';
		wait for C_CLK_PERIOD;
		pop <= '0';
		wait for 10 ns;
		pop <= '1';
		wait for C_CLK_PERIOD;
		pop <= '0';
		wait for 10 ns;
		pop <= '1';
		wait for C_CLK_PERIOD;
		pop <= '0';


	WAIT;                                                        
	END PROCESS always;                                          

END LIFO_MEMORY_arch;
