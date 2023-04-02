----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/30 23:22:33
-- Design Name: 
-- Module Name: ShiftRows - Behavioral
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

entity ShiftRows is
    Generic (
           input_width : positive:=128
           );
    Port ( input : in std_logic_vector(input_width-1 downto 0);
           output : out std_logic_vector(input_width-1 downto 0)
           );
end ShiftRows;

architecture Behavioral of ShiftRows is
--signal x,y : integer:=0;
begin

process(input)
variable x,y : integer:= 0;
begin
    for i in 0 to 3 loop
        for j in 0 to 3 loop
            x := i;
            y := (j+4-i) rem 4;
            output((y*4+x+1)*8-1 downto (y*4+x)*8) <= input((j*4+i+1)*8-1 downto (j*4+i)*8);
        end loop;
    end loop;
end process;

end Behavioral;
