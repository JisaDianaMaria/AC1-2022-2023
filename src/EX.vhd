----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.04.2023 17:05:42
-- Design Name: 
-- Module Name: EX - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EX is
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
end EX;

architecture Behavioral of EX is
signal ALUCtrl: STD_LOGIC_VECTOR(2 downto 0);
signal A,B,C: STD_LOGIC_VECTOR(15 downto 0);

begin
A<=RD1;

mux1: process(ALUSrc, RD2, Ext_Imm)
begin 
    if ALUSrc='0' then 
       B<=RD2;
    else 
       B<=Ext_Imm;
    end if; 
end process;

ALUControl1: process(ALUOp, func)
begin 
    case ALUOp is 
    when "001" =>
        case func is 
            when "000" => ALUCtrl<="000";
            when "010" => ALUCtrl<="001";
            when "001" => ALUCtrl<="010";
            when "011" => ALUCtrl<="011";
            when "100" => ALUCtrl<="100";
            when "101" => ALUCtrl<="101";
            when "110" => ALUCtrl<="110";
            when "111" => ALUCtrl<="111"; 
            when others => ALUCtrl <= (others=>'X');
         end case;
    when "000" => ALUCtrl<="000";
    when "010" => ALUCtrl<="001";
    when "011" => ALUCtrl<="101";
    when "110" => ALUCtrl<="100";
    when others => ALUCtrl <= (others=>'X');
    end case;
 end process;
 
ALUControl2: process(A,B,ALUCtrl,sa)
 begin 
    case ALUCtrl is 
        when "000" => C<=A+B;
        when "001" => C<=A-B;
        when "010" =>  --SLL
            if sa='0' then C<=A;
                      else C<=A(14 downto 0) & '0';
            end if;
        when "011" =>  --SRL
             if sa='0' then C<=A;
                       else C<= '0' & A(14 downto 0);
             end if;
        when "111" =>  --SRA
              if sa='0' then C<=A;
                        else C<= A(15) & A(14 downto 0);
              end if;     
        when "100" => C<= A and B;
        when "101" => C<= A or B;
        when "110" => C<= A xor B;
       
        when others => C<=(others => 'X');
    end case;
 end process;
 
 
 Zero<= '1' when C="0000000000000000" else '0';   
 ALURes <= C;
 BranchAddress <= PcInc + Ext_Imm;
 
   
        
        
 
end Behavioral;
