library ieee;
use ieee.std_logic_1164.all;

entity state_machine is 
port(
   opcode : in std_logic_vector(3 downto 0);
   accZ,acc15,reset,clk : in std_logic ; 
   RnW,selA,selB,pc_ld,ir_ld,acc_ld,acc_oe, memcs : out std_logic;
   alufs : out std_logic_vector(3 downto 0) ); 
end state_machine;

architecture smachine of state_machine is 
type state is (ReadNextIns, LoadIR, IncPC, Store, Jump,ReadFromMem, Load, Add, substract , LoadAcc, Stop);
signal current_state, next_state : state := ReadNextIns ; 

begin
   state_comb : process(accZ,acc15,reset,opcode,current_state)
   variable a, b, c, r1 : std_logic;
   begin
   case current_state is 
      when ReadNextIns => next_state <= LoadIR; 
      when LoadIR =>
          a := (opcode(2) AND opcode(1) AND accZ) OR
               (opcode(2) AND NOT (opcode(1) OR opcode(0))) OR
               (opcode(2) AND NOT (opcode(1) OR acc15));
           if(a='1') then next_state <= Jump ; 
           else  next_state <= IncPC ; 
           end if;
     when IncPC => 
   --  b :=  NOT(opcode(2)) AND (opcode(0) OR NOT(opcode(1)));
   --  c := (opcode(0) AND ( NOT (opcode(2) OR opcode(1))));
     r1 := (opcode(2) AND opcode(1) AND (NOT(opcode(0) OR accZ))) OR
           ( opcode(2) AND opcode(0) and acc15 and NOT(opcode(1)) );
     if(opcode = "0000" OR opcode = "0010" OR opcode = "0011") then next_state <= ReadFromMem ; 
     elsif (opcode = "0001") then next_state <= Store;
     elsif (r1 = '1') then next_state <= ReadNextIns ;
     else next_state <= Stop;
     end if;
     when ReadFromMem =>
         if (opcode = "0000") then next_state <= Load;
         elsif (opcode="0010") then next_state <= Add;
         elsif (opcode = "0011") then next_state <=substract;
         else next_state <=Stop;
         end if; 
    when Load  =>
           next_state <= LoadAcc; 
    when  Add  =>
           next_state <= LoadAcc; 
    when substract =>
           next_state <= LoadAcc; 
    when Jump  =>
            next_state <= ReadNextIns;
    when  Store  =>
            next_state <= ReadNextIns;
    when LoadAcc =>
            next_state <= ReadNextIns;
  when Stop =>
             next_state <= Stop; -- Terminal state
                
  when others =>
             next_state <= Stop; -- Default state
    end case;
  end process; 

  mem_etat : process(clk,reset)
  begin 
       if (clk'event and clk = '1') then 
           if reset = '1' then 
                 current_state <= ReadNextIns ; 
           else current_state <= next_state; 
           end if ;
      end if; 
  end process;

  output : process (current_state, accZ,acc15)
  begin 
  case current_state is 
  when ReadNextIns => 
        selA <= '0' ; 
        memcs <= '1';
        RnW <= '1' ;  --read
  when LoadIR => 
        ir_ld <= '1';
  when IncPC =>
        selB <= '0';
        alufs <= "0011";
        pc_ld <= '1'; 
  when Store =>
        selA<='1' ; 
        RnW <= '0' ;
        acc_oe <= '1';
  when Jump =>
        selA <= '1';
        selB <= '0';
        alufs <= "0000"; 
        pc_ld <= '1'; 
  when ReadFromMem =>
        selA <= '1' ; 
        Rnw <= '1';
        selB <= '1';
  when Load => 
        alufs <= "0000" ;
  when Add => 
        alufs <= "0010" ;
  when substract => 
        alufs <= "0011" ;
  when LoadAcc =>
        acc_ld <= '1'; 
  when Stop =>
        memcs <= '0' ; 
 when others =>
             memcs<= '0'; -- Default state
    end case;
  end process;

        
        
              
        
        


end smachine;