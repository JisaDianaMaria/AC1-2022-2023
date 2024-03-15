----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.04.2023 19:17:44
-- Design Name: 
-- Module Name: MEM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM is
    Port( MemWrite: in STD_LOGIC; 
          ALUResIn: in STD_LOGIC_VECTOR(15 downto 0); 
          RD2: in STD_LOGIC_VECTOR(15 downto 0);
          clk: in STD_LOGIC;
          en: in STD_LOGIC;
          MemData: out STD_LOGIC_VECTOR(15 downto 0);
          ALUResOut: out STD_LOGIC_VECTOR(15 downto 0));
end MEM;

architecture Behavioral of MEM is
type mem is array (0 to 31) of std_logic_vector(15 downto 0);
signal DataMemory: mem:=(  X"0004",
                           X"0002",
                           X"0003",
                           X"0002",
                           X"0005",
                           X"0006",
                           X"0002",
                           X"0008",
                           X"0009",
                           X"0005",
                           others=>X"0000");

begin

    process(clk)
    begin 
        if rising_edge(clk) then
            if en='1' and MemWrite='1' then
                DataMemory(conv_integer(ALUResIn(4 downto 0)))<=RD2;
            end if;
        end if;
    end process;
    
    MemData<=DataMemory(conv_integer(ALUResIn(4 downto 0)));
    ALUResOut<=ALUResIn;

end Behavioral;
