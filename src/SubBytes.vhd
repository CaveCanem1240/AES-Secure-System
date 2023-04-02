----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/30 23:22:33
-- Design Name: 
-- Module Name: SubBytes - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
library work;
use work.util_package.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SubBytes is

    Generic (
           input_width : positive:=128
           );
    Port ( 
           input : in STD_LOGIC_VECTOR(input_width-1 downto 0);
           output : out STD_LOGIC_VECTOR(input_width-1 downto 0)
           );
end SubBytes;

architecture Behavioral of SubBytes is
component Sbox is
    port (
		input_byte : in std_logic_vector(7 downto 0);
		output_byte : out std_logic_vector(7 downto 0)
	);
end component;
begin


gen_SubB_row:
    for i in 0 to 3 generate
    gen_SubB_col:
        for j in 0 to 3 generate
         begin
            sub:Sbox port map(input_byte=>input((i*4+j+1)*8-1 downto (i*4+j)*8), output_byte=>output((i*4+j+1)*8-1 downto (i*4+j)*8));
        end generate;
    end generate;

end Behavioral;
