----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/30 23:22:33
-- Design Name: 
-- Module Name: Final_Round - Behavioral
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

library work;
use work.util_package.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Final_Round is
    Generic (
           input_width : positive:=128;
           key_width : positive:=128
           );
    Port ( 
           input : in std_logic_vector(input_width-1 downto 0);
           round_key : in std_logic_vector(input_width-1 downto 0);
           output : out std_logic_vector(input_width-1 downto 0)
           );
end Final_Round;

architecture Behavioral of Final_Round is

component AddRoundKey is
    Generic (
           input_width : positive:=128;
           key_width : positive:=128
           );
    Port ( 
           input : in std_logic_vector(input_width-1 downto 0);
           round_key : in std_logic_vector(input_width-1 downto 0);
           output : out std_logic_vector(input_width-1 downto 0) 
           );
end component;
component SubBytes is
    Generic (
           input_width : positive:=128
           );
    Port ( 
           input : in STD_LOGIC_VECTOR(input_width-1 downto 0);
           output : out STD_LOGIC_VECTOR(input_width-1 downto 0)
           );
end component;
component ShiftRows is
    Generic (
           input_width : positive:=128
           );
    Port ( input : in std_logic_vector(input_width-1 downto 0);
           output : out std_logic_vector(input_width-1 downto 0)
           );
end component;

signal SubB_out,ShiftR_out,AddRK_in: std_logic_vector(input_width-1 downto 0):=(others=> '0');

begin
round1: SubBytes generic map(input_width=>input_width)
              port map(input=>input,output=>SubB_out);
round2: ShiftRows generic map(input_width=>input_width)
              port map(input=>SubB_out,output=>ShiftR_out);
round3: AddRoundKey generic map(input_width=>input_width,key_width=>key_width)
              port map(input=>AddRK_in,round_key=>round_key,output=>output);  
              
process(ShiftR_out)
begin
    for i in 0 to 15 loop
        AddRK_in((i+1)*8-1 downto i*8) <= ShiftR_out((15-i+1)*8-1 downto (15-i)*8);
    end loop;
end process;
              

end Behavioral;
