library ieee;
use ieee.std_logic_1164.all;

entity programCounter is 
port(
pc_in : in std_logic_vector(15 downto 0);
pc_id : in std_logic ;
pc_out : out std_logic_vector(11 downto 0) );
end programCounter ; 

architecture pc of programCounter is 
begin 
        process(pc_id)
              variable Next_ins : std_logic_vector(11 downto 0) := (others => 'Z'); 
              begin
                if(pc_id'event and pc_id = '1') then 
                         Next_ins:= pc_in(11 downto 0) ;
                         pc_out<= Next_ins ; 
                 else  
                              pc_out <= (others => 'Z'); 
                  
              end if ; 
          end process;
end pc ;         
