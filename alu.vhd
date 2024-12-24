library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is 
port(
     A, B : in std_logic_vector(15 downto 0 ) ;
     alufs : in std_logic_vector(3 downto 0);
      S : out std_logic_vector(15 downto 0)
 );
end alu;

architecture comp of alu is 
begin 
   p : process (A,B,alufs)
   begin 
        case alufs is 
             when "0000" => S <= B ; 
             when "0001" => S <= std_logic_vector(signed(A) - signed(B)); 
             when "0010" => S <= std_logic_vector(signed(A) + signed(B)); 
             when "0011" => S <= std_logic_vector(resize(unsigned(B) + 1, S'length));
             when others => S <= (others=>'Z');
        end case;
  end process;
end comp;
