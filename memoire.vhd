library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoire is
port( RnW,cs : in std_logic;
      add: in std_logic_vector(11 downto 0);
      data: inout std_logic_vector(15 downto 0));
 end memoire;
    
Architecture Mem of memoire is 
type RAM_ARRAY is array (0 to 4095 ) of std_logic_vector (15 downto 0);
signal RAM: RAM_ARRAY;
     begin 
     p1:process(cs,RnW)
     begin
     case cs is
   when '1' => if(RnW='0') then 
                             RAM(to_integer (unsigned (add)))<=data;
              else data<=RAM(to_integer(unsigned (add)));
              end if;
   when others =>
        data<=(others =>'Z');
   end case;
     end process;
     end mem;