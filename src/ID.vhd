----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2023 04:38:27 PM
-- Design Name: 
-- Module Name: ID - Behavioral
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

entity ID is
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
end ID;

architecture Behavioral of ID is

component reg_file is
     port ( clk : in std_logic;
            ra1 : in std_logic_vector (2 downto 0);
            ra2 : in std_logic_vector (2 downto 0);
            wa : in std_logic_vector (2 downto 0);
            wd : in std_logic_vector (15 downto 0);
            wen : in std_logic;
            en : in std_logic;
            rd1 : out std_logic_vector (15 downto 0);
            rd2 : out std_logic_vector (15 downto 0));
end component;

signal fmux: std_logic_vector(2 downto 0);
signal instrExt: std_logic_vector(15 downto 0);
begin

process(instr(9 downto 7),instr(6 downto 4), RegDst)
begin 
    if RegDst='1' then 
        fmux<=instr(6 downto 4);
    else fmux<=instr(9 downto 7);
    end if;
end process;

process(instr(6 downto 0),ExtOp)
begin 
    if ExtOp='1' then 
        instrExt<=instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6)&instr(6 downto 0);
    else instrExt<="000000000"&instr(6 downto 0);
    end if;
end process;

regfile: reg_file port map(clk,instr(12 downto 10), instr(9 downto 7), fmux, wd, RegWrite, en,rd1, rd2 );

func<=instr(2 downto 0);
sa<= instr(3);
ext_Imm<=instrExt;


end Behavioral;