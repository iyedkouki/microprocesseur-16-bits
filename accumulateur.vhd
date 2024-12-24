library ieee;
use ieee.std_logic_1164.all;

-- Accumulator Component
entity accumulateur is
    port (
        data_in  : in std_logic_vector(15 downto 0);
        acc_ld   : in std_logic;
        clk      : in std_logic;  -- Clock signal
        data_out : out std_logic_vector(15 downto 0);
        accZ     : out std_logic;
        acc15    : out std_logic
    );
end accumulateur;

-- Accumulator Architecture
architecture acc16 of accumulateur is
    signal data : std_logic_vector(15 downto 0) := (others => 'Z');  -- Initialize with high impedance
    constant zero_data : std_logic_vector(15 downto 0) := (others => '0'); -- Constant for zero comparison
begin
    -- Clocked process for accumulator functionality
    process(clk)
    begin
        if rising_edge(clk) then
            if acc_ld = '1' then
                data <= data_in;  -- Load data from input
            end if;
        end if;
    end process;

    -- Output assignment
    data_out <= data;  -- Output the data value (either loaded or unchanged)

    -- Zero detection logic for accumulator
    process(data)
    begin
        if data = zero_data then
            accZ <= '1';  -- Set accZ to '1' if data is zero
        else
            accZ <= '0';  -- Set accZ to '0' if data is not zero
        end if;
    end process;

    -- Assign the most significant bit of the data to acc15
    acc15 <= data(15);

end acc16;

