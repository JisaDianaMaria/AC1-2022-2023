----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2023 10:07:03
-- Design Name: 
-- Module Name: test_env - Behavioral
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity testenv is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_VECTOR (4 downto 0);
           sw : in STD_LOGIC_VECTOR (15 downto 0);
           led : out STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end testenv;

architecture Behavioral of testenv is
signal en, rst: STD_LOGIC;
signal ALUOp: STD_LOGIC_VECTOR(2 downto 0);
signal RegDest, ALUSrc, Jump, MemWrite, MemtoReg, RegWrite, Branch, ExtOp: STD_LOGIC;
signal func: STD_LOGIC_VECTOR(2 downto 0);
signal sa: STD_LOGIC;
signal digits: STD_LOGIC_VECTOR(15 downto 0);
signal Instruction, PCinc, RD1, RD2, sum, Ext_Imm, Ext_func, Ext_sa:  STD_LOGIC_VECTOR(15 downto 0);
signal BranchAddress, JumpAddress: STD_LOGIC_VECTOR(15 downto 0);
signal PCSrc, Zero: STD_LOGIC;
signal WD, MemData, AluRes, AluRes1: STD_LOGIC_VECTOR(15 downto 0);



component MPG is
    Port ( en : out STD_LOGIC;
           input : in STD_LOGIC;
           clock : in STD_LOGIC);
end component;

component SSD is
 Port ( clk: in STD_LOGIC;
          digits: in STD_LOGIC_VECTOR(15 downto 0);
          an: out STD_LOGIC_VECTOR(3 downto 0);
          cat: out STD_LOGIC_VECTOR(6 downto 0));
end component;

component InstructionFetch is
  Port(J: in std_logic;
      JA: in std_logic_vector(15 downto 0);
      PCS: in std_logic;
      BA: in std_logic_vector(15 downto 0);
      en: in std_logic;
      rst: in std_logic;
      clk: in std_logic;
      PC: out std_logic_vector(15 downto 0);
      instr: out std_logic_vector(15 downto 0));
end component;

component ID is
     Port (instr: in std_logic_vector(15 downto 0);
            clk: in std_logic;
            en: in std_logic;
            wd: in std_logic_vector(15 downto 0);
            rd1: out std_logic_vector(15 downto 0);
            rd2: out std_logic_vector(15 downto 0);
            ext_imm: out std_logic_vector(15 downto 0);
            func: out std_logic_vector(2 downto 0);
            sa: out std_logic;
            RegWrite: in std_logic;
            RegDst: in std_logic;
            ExtOp: in std_logic);
end component;

component MainControl is
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
end component;

component EX is
    Port( RD1: in STD_LOGIC_VECTOR(15 downto 0);
          ALUSrc: in STD_LOGIC;
          RD2: in STD_LOGIC_VECTOR(15 downto 0);
          Ext_Imm: in STD_LOGIC_VECTOR(15 downto 0);
          sa: in STD_LOGIC;
          func: in STD_LOGIC_VECTOR(2 downto 0);
          ALUOp: in STD_LOGIC_VECTOR(2 downto 0);
          PcInc: in STD_LOGIC_VECTOR(15 downto 0);
          Zero: out STD_LOGIC;
          ALURes: out STD_LOGIC_VECTOR(15 downto 0);
          BranchAddress: out STD_LOGIC_VECTOR(15 downto 0));          
end component;

component MEM is
    Port( MemWrite: in STD_LOGIC; 
          ALUResIn: in STD_LOGIC_VECTOR(15 downto 0); 
          RD2: in STD_LOGIC_VECTOR(15 downto 0);
          clk: in STD_LOGIC;
          en: in STD_LOGIC;
          MemData: out STD_LOGIC_VECTOR(15 downto 0);
          ALUResOut: out STD_LOGIC_VECTOR(15 downto 0));
end component;


begin

	monopulse1: MPG port map(en, btn(0), clk);
	monopulse2: MPG port map(rst, btn(1), clk);
	inst_IF: InstructionFetch port map(Jump, JumpAddress, PCSrc, BranchAddress, en, rst, clk, PCinc, Instruction);
	inst_ID: ID port map(Instruction, clk, en, WD, RD1, RD2, Ext_Imm, func, sa, RegWrite, RegDest, ExtOp);
	inst_MC: MainControl port map(Instruction(15 downto 13), RegDest, ExtOp, ALUSrc, Branch, Jump, ALUOP, MemWrite, MemtoReg, RegWrite);
	inst_EX: EX port map(RD1, ALUSrc, RD2, Ext_Imm, sa, func, ALUOP, PcInc, Zero, AluRes, BranchAddress);
	inst_MEM: MEM port map(MemWrite, AluRes, RD2, clk, en, MemData, AluRes1);
	
	
	
	with MemtoReg select
	  WD <= MemData when '1',
	        AluRes1 when '0',
	        (others => 'X') when others;
	
	PCSrc <= Zero and Branch;
	JumpAddress <= PCInc(15 downto 13) & Instruction(12 downto 0);
	
	with sw(7 downto 5) select
  	    digits <=  Instruction when "000",
  	               PCinc when "001",
  	               RD1 when "010",
  	               RD2 when "011",
  	               Ext_Imm when "100",
  	               ALURes when "101",
  	               MemData when "110",
  	               WD when "111",
		      (others => 'X') when others;

	display: SSD port map(clk, digits, an, cat);
	
	led(10 downto 0) <= ALUOp & RegDest & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;

end Behavioral;