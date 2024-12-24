library ieee;
use ieee.std_logic_1164.all;

entity multiplixeur is 
   generic (
         width : integer := 16 );
   port( data_0 , data_1 : in std_logic_vector( width-1 downto 0) ;
      sel : in std_logic ; 
      data: out std_logic_vector( width-1 downto 0));
end multiplixeur; 

architecture mux of multiplixeur is 
   begin 
      p : process(sel,data_0,data_1)
          begin 
          case sel is 
                when '0' => data<=data_0;
                when '1'=> data<=data_1;
                when others => data <= (others=>'Z');
             end case;
          end process p ; 
   end mux;
      