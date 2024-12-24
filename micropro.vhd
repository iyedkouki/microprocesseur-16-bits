library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Entity: Microprocessor
entity micropro is 
    port (
        clk, reset : in std_logic
    );
end micropro;

architecture mp16 of micropro is 

    -- Signals Declaration
    signal RnW, selA, selB, pc_ld, ir_ld, acc_ld, acc_oe, memcs : std_logic;
    signal alufs : std_logic_vector(3 downto 0);
    signal accZ, acc15 : std_logic;
    signal ir_out : std_logic_vector(11 downto 0);
    signal opcode : std_logic_vector(3 downto 0);
    signal alu_result, bus_data, acc_data, mem_data, mux_a_out, mux_b_out : std_logic_vector(15 downto 0);
    signal pc_out : std_logic_vector(11 downto 0);

    -- Components Declaration
    component state_machine is 
        port(
            opcode    : in std_logic_vector(3 downto 0);
            accZ, acc15, reset, clk : in std_logic; 
            RnW, selA, selB, pc_ld, ir_ld, acc_ld, acc_oe, memcs : out std_logic;
            alufs : out std_logic_vector(3 downto 0)
        ); 
    end component;

    component memoire is
        port(
            RnW, cs : in std_logic;
            add : in std_logic_vector(11 downto 0);
            data : inout std_logic_vector(15 downto 0)
        );
    end component;

    component accumulateur is 
        port(
            data_in  : in std_logic_vector(15 downto 0);
            acc_ld, clk : in std_logic;
            data_out : out std_logic_vector(15 downto 0);
            accZ, acc15 : out std_logic
        );
    end component;

    component alu is 
        port(
            A, B : in std_logic_vector(15 downto 0);
            alufs : in std_logic_vector(3 downto 0);
            S : out std_logic_vector(15 downto 0)
        );
    end component;

    component InstructionRegister is 
        port(
            ir_in : in std_logic_vector(15 downto 0);
            ir_ld : in std_logic;
            ir_out : out std_logic_vector(11 downto 0);
            opcode : out std_logic_vector(3 downto 0)
        );
    end component;

    component multiplixeur is 
        generic (width : integer := 16);
        port(
            data_0, data_1 : in std_logic_vector(width-1 downto 0);
            sel : in std_logic; 
            data : out std_logic_vector(width-1 downto 0)
        );
    end component;

    component programCounter is 
        port(
            pc_in : in std_logic_vector(15 downto 0);
            pc_id : in std_logic;
            pc_out : out std_logic_vector(11 downto 0)
        );
    end component;

    component output_enable is 
        port(
            a : in std_logic_vector(15 downto 0); 
            acc_oe : in std_logic; 
            s : out std_logic_vector(15 downto 0)
        );
    end component;

begin 

    -- State Machine
    state_machine_inst : state_machine
        port map(
            opcode   => opcode,
            accZ     => accZ,
            acc15    => acc15,
            reset    => reset,
            clk      => clk,
            RnW      => RnW,
            selA     => selA,
            selB     => selB,
            pc_ld    => pc_ld,
            ir_ld    => ir_ld,
            acc_ld   => acc_ld,
            acc_oe   => acc_oe,
            memcs    => memcs,
            alufs    => alufs
        );

    -- Memory
    memory_inst : memoire
        port map(
            RnW  => RnW,
            cs   => memcs,
            add  => pc_out,
            data => mem_data
        );

    -- Instruction Register
    ir_inst : InstructionRegister
        port map(
            ir_in  => mem_data,
            ir_ld  => ir_ld,
            ir_out => ir_out,
            opcode => opcode
        );

    -- Program Counter
    pc_inst : programCounter
        port map(
            pc_in  => mem_data,
            pc_id  => pc_ld,
            pc_out => pc_out
        );

    -- Multiplexer A (for ALU input A)
    muxA_inst : multiplixeur
        port map(
            data_0 => mem_data,
            data_1 => acc_data,
            sel    => selA,
            data   => mux_a_out
        );

    -- Multiplexer B (for ALU input B)
    muxB_inst : multiplixeur
        port map(
            data_0 => mem_data,
            data_1 => "0000000000000001",  -- Constant for increment
            sel    => selB,
            data   => mux_b_out
        );

    -- ALU
    alu_inst : alu
        port map(
            A     => mux_a_out,
            B     => mux_b_out,
            alufs => alufs,
            S     => alu_result
        );

    -- Accumulator
    acc_inst : accumulateur
        port map (
            data_in => alu_result,          -- ALU result is fed into the accumulator
            acc_ld  => acc_ld,              -- Load signal for accumulator
            data_out => acc_data,           -- Output of the accumulator
            accZ => accZ,                   -- Zero flag from accumulator
            acc15 => acc15,                 -- MSB of accumulator
            clk => clk                      -- Clock signal
        );

    -- Output Enable
    oe_inst : output_enable
        port map(
            a      => acc_data,
            acc_oe => acc_oe,
            s      => bus_data
        );

end mp16;

