----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.03.2023 17:17:42
-- Design Name: 
-- Module Name: InstructionFetch - Behavioral
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

entity InstructionFetch is
  Port(J: in std_logic;
      JA: in std_logic_vector(15 downto 0);
      PCS: in std_logic;
      BA: in std_logic_vector(15 downto 0);
      en: in std_logic;
      rst: in std_logic;
      clk: in std_logic;
      PC: out std_logic_vector(15 downto 0);
      instr: out std_logic_vector(15 downto 0));
end entity;

architecture Behavioral of InstructionFetch is  
type mem is array (0 to 255) of std_logic_vector(15 downto 0);
signal ROM: mem:=(  B"000_000_000_010_0_000",   --X"0020" -- 00: add $2, $0, $0 ; initializarea indexului locatiei de memorie cu 0
                    B"100_000_100_0001010",     --X"820A" -- 01: addi $4, $0, 10 ; se salveaza numarul maxim de iteratii (10)
                    B"000_000_000_101_0_000",   --X"0050" -- 02: add $5, $0, $0 ; sum = 0
                    B"100_000_110_0000010",     --X"8302" -- 03: addi $6, $0, 2 ; o constanta care nu este adaugata in suma
                    B"100_000_001_0000000",     --X"8080" -- 04: addi $1, $0, 0 ; i = 0, contorul buclei
                    B"110_100_001_0000111",     --X"D087" -- 05: beq $4, $1, 7 ; s-au facut 10 iteratii daca da, salt în afara buclei
                    B"001_010_011_0000000",     --X"2980" -- 06: lw $3, 0($2)   ; se încarca elementul curent din sir
                    B"000_011_110_111_0_010",   --X"0F72" -- 07: sub $7, $3, $6 ; verificam daca numarul curent este egal cu 2
                    B"110_111_000_0000001",     --X"DC01" -- 08: beq $7, $0, 1 ; daca numarul este egal cu 2, trecem la urmatoarea iteratie
                    B"000_101_011_101_0_000",   --X"15D0" -- 09: add $5, $5, $3 ; daca valoarea este diferita de 2, se adauga la sum
                    B"100_010_010_0000001",     --X"8901" -- 10: addi $2, $2, 1 ; indexul urmatorului element din sir
                    B"100_001_001_0000001",     --X"8481" -- 11: addi $1, $1, 1 ; i=i+1, actualizarea contorului buclei
                    B"011_0000000000101",       --X"6005" -- 12: j 5           ; salt începutul buclei
                    B"111_000_101_1010000",     --X"E2D0" -- 13: sw $5, 80($0) ; salvarea sumei în memorie la adresa 80
                    others=>X"0000");

signal q: std_logic_vector(15 downto 0);
signal d: std_logic_vector(15 downto 0);
signal mux_out: std_logic_vector(15 downto 0);
signal sum_out: std_logic_vector(15 downto 0);

begin
 programCounter: process(clk)
                  begin
                  if rising_edge(clk) then
                  if rst='1' then
                     q<=X"0000";
                  elsif en='1' then
                     q<=d;
                 end if;
                 end if;
                 end process;
                 
 MUX1:process(J,JA,mux_out)
      begin
       if(J='1') then d<=JA;
       else d<=mux_out;
       end if;
       end process;
       
 MUX2:process(PCS,BA,sum_out)
      begin
      if(PCS='1') then mux_out<=BA;
      else mux_out<=sum_out;
      end if;
      end process;
      
instr<=ROM(conv_integer(q(4 downto 0))); 
sum_out<=q+1;
PC<=sum_out;

end Behavioral;