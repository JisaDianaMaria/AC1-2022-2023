----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.04.2023 17:18:57
-- Design Name: 
-- Module Name: MainControl - Behavioral
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

entity MainControl is
    Port( Instr: in STD_LOGIC_VECTOR(15 downto 13);
          RegDest: out STD_LOGIC;
          ExtOp: out STD_LOGIC;
          ALUSrc: out STD_LOGIC;
          Branch: out STD_LOGIC;
          Jump: out STD_LOGIC;
          ALUOP: out STD_LOGIC_VECTOR(2 downto 0);
          MemWrite: out STD_LOGIC;
          MemtoReg: out STD_LOGIC;
          RegWrite: out STD_LOGIC);
end MainControl;


architecture Behavioral of MainControl is

begin

process(Instr(15 downto 13))
begin 
    RegDest<='0'; ExtOp<='0'; ALUSrc<='0';
    Branch<='0'; Jump<='0'; MemWrite<='0';
    MemtoReg<='0'; RegWrite<='0'; ALUOp<="000";
    
    case Instr(15 downto 13) is
        when "000" =>
            RegDest<='1'; RegWrite<='1';
            ALUOP<="001";
        when "100" =>
            ExtOp<='1'; ALUSrc<='1'; RegWrite<='1';
            ALUOP<="000";
        when "001" =>
            ExtOp<='1'; ALUSrc<='1'; MemtoReg<='1'; RegWrite<='1';
            ALUOP<="000";
        when "111" =>
             ExtOp<='1'; ALUSrc<='1'; MemWrite<='1'; 
             ALUOP<="000";
        when "110" =>
             ExtOp<='1'; Branch<='1'; 
             ALUOP<="010";
        when "101" =>
              ALUSrc<='1'; RegWrite<='1';
              ALUOP<="011";
       when "010" =>
              ExtOp<='1'; ALUSrc<='1'; RegWrite<='1';
              ALUOP<="110";
       when "011" =>
              Jump<='1'; 
       when others => RegDest<='0';
    end case; 
end process;

end Behavioral;
