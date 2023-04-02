----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/11/30 23:10:27
-- Design Name: 
-- Module Name: AES - Behavioral
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

entity AES is
    Generic (
           input_width : positive:=128;
           key_width : positive:=128
           );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR(key_width-1 downto 0);
           load_key : in STD_LOGIC;
           new_key : in STD_LOGIC;
           key_exp_done : out STD_LOGIC;
           output : out STD_LOGIC_VECTOR(input_width-1 downto 0);
           output_done : out STD_LOGIC
           );
end AES;

architecture Behavioral of AES is
component Key_Expansion is 
    Generic (
           input_width : positive:=128;
           key_width : positive:=128
           );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;  
           new_key : in STD_LOGIC;
           key_exp_done : out STD_LOGIC;
           input : in STD_LOGIC_VECTOR(key_width-1 downto 0);
           output : out STD_LOGIC_VECTOR((10+(key_width-128)/32+1)*input_width-1 downto 0)
           );
end component;
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
component Rounds is
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
component Final_Round is
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
signal round_cnt:integer:=0;

signal input_mat,output_mat : std_logic_vector(input_width-1 downto 0) := (others => '0');
signal key_exp_mat : std_logic_vector((10+(key_width-128)/32+1)*input_width-1 downto 0) := (others => '0');
signal exp_done_sig: STD_LOGIC:='0';
signal key : STD_LOGIC_VECTOR(key_width-1 downto 0);

signal init_round_output: std_logic_vector(input_width-1 downto 0) := (others => '0');
signal round_key_sig : std_logic_vector(input_width-1 downto 0) := (others => '0');
signal rounds_output,final_output: std_logic_vector(input_width-1 downto 0) := (others => '0');

begin

process(rst,clk)
begin
    if rst = '1' then
        key <= (others => '0');
    elsif rising_edge(clk) then
        if load_key = '1' then
            key <= input;
        end if;
    end if;
end process;

gen_key_exp: 
    Key_Expansion 
         generic map(input_width=>input_width,key_width => key_width)
         port map(clk=>clk,rst=>rst,new_key=>new_key,key_exp_done=>key_exp_done,input=>key, output=>key_exp_mat);

gen_init_round:
     AddRoundKey
         generic map(input_width=>input_width,key_width => key_width)
         port map(input=>input(input_width-1 downto 0),round_key=>key_exp_mat(127 downto 0),output=>init_round_output);
    

gen_rounds:
    Rounds 
        generic map(input_width=>input_width,key_width=>key_width)
        port map(input=>input_mat,round_key=>round_key_sig,output=>output_mat);

gen_final_round:
    Final_Round 
        generic map(input_width=>input_width,key_width => key_width)
        port map(input=>rounds_output,round_key=>key_exp_mat(128*(10+(key_width-128)/32+1)-1 downto 128*(10+(key_width-128)/32)),output=>final_output);
process(final_output)
begin
    for i in 0 to 15 loop
        output((i+1)*8-1 downto i*8) <= final_output((16-i)*8-1 downto (15-i)*8);
    end loop;
end process;

process(clk,rst)
variable start_rounds:STD_LOGIC:='0';
begin
    if rst = '1' then
        round_cnt <= 0;
    elsif rising_edge(clk) then
        output_done <= '0';
        if key_exp_done = '1' then
            start_rounds := '1';
        end if;
        if  start_rounds = '1' then
            if round_cnt= 0 then
                input_mat <= init_round_output;
                round_key_sig <= key_exp_mat(128*2-1 downto 128);
                round_cnt <= round_cnt+1;
            elsif round_cnt <= (10+(key_width-128)/32-2) then
                round_key_sig <= key_exp_mat(128*(round_cnt+2)-1 downto 128*(round_cnt+1));
                input_mat <= output_mat;
                round_cnt <= round_cnt+1;
            elsif round_cnt = 10+(key_width-128)/32-1 then
                rounds_output <= output_mat;
                round_cnt <= round_cnt+1;
            elsif round_cnt = 10+(key_width-128)/32 then
                output_done <= '1';
                start_rounds := '0';
                round_cnt <= 0;
            end if;
        end if;
    end if;
end process;

end Behavioral;
