----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/30 23:22:33
-- Design Name: 
-- Module Name: AddRoundKey - Behavioral
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

entity AddRoundKey is
    Generic (
           input_width : positive:=128;
           key_width : positive:=128
           );
    Port ( 
           input : in std_logic_vector(input_width-1 downto 0);
           round_key : in std_logic_vector(input_width-1 downto 0);
           output : out std_logic_vector(input_width-1 downto 0)
           );
end AddRoundKey;

architecture Behavioral of AddRoundKey is

begin
process(input,round_key)
begin
    for i in 0 to 15 loop
        output((i+1)*8-1 downto i*8) <= input((16-i)*8-1 downto (15-i)*8) xor round_key((i+1)*8-1 downto i*8);
    end loop;
end process;

end Behavioral;
