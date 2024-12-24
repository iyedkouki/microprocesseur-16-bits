library ieee;
use ieee.std_logic_1164.all;

entity output_enable is 
port ( a : in std_logic_vector(15 downto 0 ); 
       acc_oe : in std_logic ; 
       s : out std_logic_vector(15 downto 0) );
end output_enable;
architecture oe of output_enable is 
begin 
 p: process(acc_oe)
 begin 
  if(acc_oe = '1') then 
     s<= a ; 
   else s<= (others => 'Z'); 
  end if ; 
 end process ;
end oe; 