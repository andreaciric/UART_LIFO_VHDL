----------------------------------------------------------------------------------
-- Project Name: LIFO MEMORY (LIFO - Last In First Out = stack)
--
-- Author: Andrea Ćirić
--
-- Description: 
--
-- Implements a simple stack with a generic data size and a
-- generic memory size that could be changed dpending on the need. 
--
-- The stack has two control signals, push and pop. When push is high,
-- the value on the data input is added to the stack. When pop is high
-- the top value on the stack is removed.
--
-- Any attempt to add a value to a full stack or pop from empty stack
-- is ignored and error outputs (is_full and is_empty) are generated.
-- 
-- 
-- Inputs/Outputs:
--
--    clock           - system clock
--    restart         - reset signal
--
--    data_in         - input value to be put on top
--    data_out        - output value removed from the top
--
--    pop             - input value if high then remove data from the top
--    push            - input value if high then write data to the top
--
--    is_full         - output value if high that means stack is full
--    is_empty        - output value if high that means stack is empty
--
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LIFO_MEMORY is
    generic(
        data_size   : natural := 8;
        memory_size : natural := 256
    );
    port(
        data_in         : in  std_logic_vector(data_size - 1 downto 0); 
        data_out        : out std_logic_vector(data_size - 1 downto 0); 
        pop             : in  std_logic; 
        push            : in  std_logic;
        is_full         : out std_logic; 
        is_empty        : out std_logic; 
        clock           : in  std_logic;
        restart         : in  std_logic
    );
end LIFO_MEMORY;

architecture Behavioral of LIFO_MEMORY is
    
    type memory_type is array (1 to memory_size) of std_logic_vector(data_size - 1 downto 0);
    signal memory : memory_type;
    
    function f_logic_to_std(B : boolean) return std_logic is
    begin
        if B = false then
            return '0';
        else
            return '1';
        end if;
    end function f_logic_to_std;
    
begin

  main: process(clock, restart) is
    
        variable stack_pointer : integer range 0 to memory_size := 0;
        variable empty, full   : boolean                        := false;
    
    begin
        
        if restart = '1' then
            memory <= (others => (others => '0'));
            empty := true;
            full := false;
            stack_pointer := 0;
            
        elsif rising_edge(clock) then
            if pop = '1' then
                -- READ
                if not empty then
                    data_out <= memory(stack_pointer);
                    stack_pointer := stack_pointer - 1;
                end if;
            end if;
            
            if push = '1' then
                --WRITE
                if not full then                 
                    stack_pointer := stack_pointer + 1;
                    memory(stack_pointer) <= data_in;
                end if;
            end if;

            -- Check if empty
            if stack_pointer = 0 then
                empty := true;
            else
                empty := false;
            end if;

            -- Check if full
            if stack_pointer = memory_size then
                full := true;
            else
                full := false;
            end if;
        end if;
        
        is_full  <= f_logic_to_std(full);
        is_empty <= f_logic_to_std(empty);
    end process main;

end architecture Behavioral;