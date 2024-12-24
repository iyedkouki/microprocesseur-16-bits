library ieee;
use ieee.std_logic_1164.all; 

entity InstructionRegister is 
port( ir_in : in std_logic_vector(15 downto 0);
ir_ld : in std_logic ;
ir_out : out std_logic_vector(11 downto 0) ;
opcode : out std_logic_vector(3 downto 0));
 
end InstructionRegister;


architecture IR of InstructionRegister is 
begin
          process(ir_ld)
              variable ins : std_logic_vector(11 downto 0) := (others => 'Z'); 
              begin
                if(ir_ld'event and ir_ld = '1') then 
                        ins := ir_in(15 downto 0);
                        ir_out <= ins ;
                        opcode <= ins(15 downto 12 ) ;
               else 
                         ir_out <= (others => 'Z'); 
                         opcode <= (others => 'Z'); 
                end if;
          end process ;
end IR;

