library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Testbench for Microprocessor
entity tb_micropro is
end tb_micropro;

architecture behavior of tb_micropro is

    -- Declare signals for connecting the microprocessor entity
    signal clk, reset   : std_logic := '0';
    signal RnW, selA, selB, pc_ld, ir_ld, acc_ld, acc_oe, memcs : std_logic;
    signal alufs : std_logic_vector(3 downto 0);
    signal accZ, acc15 : std_logic;
    signal ir_out : std_logic_vector(11 downto 0);
    signal opcode : std_logic_vector(3 downto 0);
    signal alu_result, bus_data, acc_data, mem_data, mux_a_out, mux_b_out : std_logic_vector(15 downto 0);
    signal pc_out : std_logic_vector(11 downto 0);

    -- Instantiate the microprocessor (unit under test)
    component micropro is 
        port (
            clk, reset : in std_logic
        );
    end component;

begin

    -- Instantiate the microprocessor under test
    uut: micropro
        port map (
            clk => clk,
            reset => reset
        );

    -- Clock generation process
    clk_process: process
    begin
        clk <= '0';
        wait for 10 ns;  -- Set the clock period to 20 ns (50 MHz)
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Stimulus process (apply inputs to the microprocessor)
    stimulus_process: process
    begin
        -- Apply reset signal
        reset <= '1';  -- Assert reset
        wait for 20 ns;
        reset <= '0';  -- Deassert reset
        wait for 20 ns;

        -- Test Case 1: Load opcode and test the state machine
        opcode <= "0101";  -- Example opcode
        wait for 20 ns;

        -- Test Case 2: Perform ALU operation
        RnW <= '1';  -- Enable read/write
        selA <= '0';  -- Select appropriate input for A (memory data)
        selB <= '1';  -- Select appropriate input for B (constant value for increment)
        pc_ld <= '1';  -- Load program counter
        ir_ld <= '1';  -- Load instruction register
        acc_ld <= '1';  -- Load accumulator
        acc_oe <= '1';  -- Output enable for accumulator
        memcs <= '1';  -- Enable memory chip select
        wait for 40 ns;  -- Wait for the operations to complete

        -- Test Case 3: Check accumulator value
        assert (acc_data = "0000000000001010") report "Test Failed: Accumulator should hold value 10." severity error;

        -- Test Case 4: Check the program counter output
        assert (pc_out = "0000000000010001") report "Test Failed: PC value mismatch." severity error;

        -- Test Case 5: Check ALU result
        assert (alu_result = "0000000000000011") report "Test Failed: ALU result mismatch." severity error;

        -- End simulation after a few cycles
        wait for 100 ns;
        assert false report "End of simulation." severity failure;
    end process;

end behavior;

