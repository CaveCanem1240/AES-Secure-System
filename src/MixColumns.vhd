----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/30 23:22:33
-- Design Name: 
-- Module Name: MixColumns - Behavioral
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

entity MixColumns is
    Generic (
           input_width : positive:=128
           );
    Port ( input : in std_logic_vector(input_width-1 downto 0);
           output : out std_logic_vector(input_width-1 downto 0)
           );
end MixColumns;

architecture Behavioral of MixColumns is
type mat_row is array(3 downto 0) of std_logic_vector(7 downto 0);
type mat is array(3 downto 0) of mat_row;
signal inp_mat,out_mat : mat:=(others => (others => (others => '0')));
signal Mix : mat:=((x"02",x"03",x"01",x"01"),(x"01",x"02",x"03",x"01"),(x"01",x"01",x"02",x"03"),(x"03",x"01",x"01",x"02"));
--signal Mix : mat:=((x"02",x"01",x"01",x"03"),(x"03",x"02",x"01",x"01"),(x"01",x"03",x"02",x"01"),(x"01",x"01",x"03",x"02"));
--signal Mix : mat:=((x"02",x"01",x"01",x"03"),(x"03",x"02",x"01",x"01"),(x"01",x"03",x"02",x"01"),(x"01",x"01",x"03",x"02"));
begin

process(input)
begin
    for row in 3 downto 0 loop
        for col in 3 downto 0 loop
            inp_mat(3-row)(3-col) <= input((col*4+row+1)*8-1 downto (col*4+row)*8);
        end loop;
    end loop;
end process;


process(inp_mat)
variable tmp_res : std_logic_vector(7 downto 0) :=(others => '0');
begin
    for row in 0 to 3 loop
        for col in 0 to 3 loop
            tmp_res := (others => '0');
            for k in 0 to 3 loop
                case Mix(row)(k) is
                    when x"01" => tmp_res := tmp_res xor inp_mat(k)(col);
                    when x"02" => 
                        if inp_mat(k)(col)(7) = '1' then
                            tmp_res := tmp_res xor ((inp_mat(k)(col)(6 downto 0) & '0') xor "00011011");
                        else
                            tmp_res := tmp_res xor (inp_mat(k)(col)(6 downto 0) & '0');
                        end if;
                    when x"03"=>
                        if inp_mat(k)(col)(7) = '1' then
                            tmp_res := tmp_res xor ((inp_mat(k)(col)(6 downto 0) & '0') xor "00011011") xor inp_mat(k)(col);
                        else
                            tmp_res := tmp_res xor (inp_mat(k)(col)(6 downto 0) & '0') xor inp_mat(k)(col);
                        end if;
                    when others => null;
                end case;
            end loop;
            output((col*4+row+1)*8-1 downto (col*4+row)*8) <= std_logic_vector(tmp_res); 
        end loop;
    end loop;

end process;

end Behavioral;
