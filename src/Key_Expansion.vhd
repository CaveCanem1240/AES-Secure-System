----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/12/03 19:47:25
-- Design Name: 
-- Module Name: Key_Expansion - Behavioral
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

entity Key_Expansion is
    Generic (
           input_width : positive:=128;
           key_width : positive :=128
           );
    Port ( clk : in STD_LOGIC; 
           rst : in STD_LOGIC; 
           new_key : in STD_LOGIC;
           key_exp_done : out STD_LOGIC;
           input : in STD_LOGIC_VECTOR (key_width-1 downto 0);
           output : out STD_LOGIC_VECTOR ((10+(key_width-128)/32+1)*input_width-1 downto 0)
           );
end Key_Expansion;

architecture Behavioral of Key_Expansion is
component Sbox is
    port (
		input_byte : in std_logic_vector(7 downto 0);
		output_byte : out std_logic_vector(7 downto 0)
	);
end component;
type key_array is array(key_width/8-1 downto 0) of std_logic_vector(7 downto 0);
signal key : key_array :=(others => (others => '0'));

type word_array is array(4*(10+(key_width-128)/32+1)-1 downto 0) of std_logic_vector(31 downto 0);
signal word : word_array := (others => (others => '0'));
signal SubWord_in, SubWord_out : std_logic_vector(31 downto 0):=(others =>'0');

signal temp : std_logic_vector(31 downto 0):=(others => '0');

signal init_key,init_word : std_logic:='0';
signal RC_value:std_logic_vector(7 downto 0):=(others =>'0');
signal word_cnt:integer:=0;
signal flag:integer:=0;
signal key_exp:std_logic:='0';
begin

process(clk,rst)
begin
    if rst = '1' then
        init_key<='0';
    elsif rising_edge(clk) then
        init_key<='0';
        if new_key = '1' then
            for i in key_width/8-1 downto 0 loop
                key(key_width/8-1-i) <= input((i+1)*8-1 downto i*8);
            end loop;
            init_key<='1';
        end if;
    end if;
end process;

gen_subword:
    for i in 0 to 3 generate
    begin
        sub: Sbox port map (input_byte => SubWord_in(((i+1)*8-1) downto i*8), output_byte => SubWord_out(((i+1)*8-1) downto i*8));
    end generate;



process(clk,rst)
variable tmp_temp : std_logic_vector(31 downto 0):=(others => '0');
--variable word_cnt:integer:=0;
variable tmp_word_array:word_array:=(others => (others=> '0'));
--variable flag:std_logic:='0';
begin
    if rst = '1' then
        init_word <= '0';
        flag <= 0;
        word_cnt <= 0;
    elsif rising_edge(clk) then
        
        if init_key= '1' then
            for i in 0 to key_width/32-1 loop
                word(i) <= key(4*i+3) & key(4*i+2) & key(4*i+1) & key(4*i); 
            end loop;
            word_cnt <= key_width/32;
            init_word <= '1';
        elsif init_word='1' then
            if word_cnt <= 4*(10+(key_width-128)/32+1)-1 and word_cnt>=key_width/32 then
            --for i in key_width/32 to key_width/32*11-1 loop
                --temp := word(i-1);
                
                if  (word_cnt mod (key_width/32)) = 0 then
                    --temp := SubWord_out xor (RC(i/4) & std_logic_vector(to_unsigned(0,24)));
                    RC_value <= RC(word_cnt/(key_width/32));
                    tmp_temp := SubWord_out xor (std_logic_vector(to_unsigned(0,24)) & RC(word_cnt/(key_width/32)) );
                    flag <= 0;
                    word(word_cnt) <= word(word_cnt-(key_width/32)) xor tmp_temp;
                    word_cnt <= word_cnt+1;
                elsif key_width/32 = 8 and (word_cnt mod 8) = 4 then
                    word(word_cnt) <= word(word_cnt-(key_width/32)) xor SubWord_out;
                    word_cnt <= word_cnt+1;
                else
                    word(word_cnt) <= word(word_cnt-(key_width/32)) xor temp;
                    word_cnt <= word_cnt+1;
                end if;
                --word(word_cnt) <= word(word_cnt-4) xor tmp_temp;
            --end loop;
                --word_cnt := word_cnt+1;
            elsif word_cnt = 4*(10+(key_width-128)/32+1) then
                word_cnt <= 0;
            end if;
        end if;
    end if;
end process;

process(word_cnt)
begin
    if word_cnt >= key_width/32 then
        temp <= word(word_cnt-1);
    end if;
end process;

process(clk,rst)
begin
    if rst = '1' then
        key_exp_done <= '0';
    elsif rising_edge(clk) then
        key_exp_done <= '0';
        if word_cnt = 4*(10+(key_width-128)/32+1) then
            key_exp_done <= '1';
        end if;
    end if;
end process;

process(temp)
begin
    if key_width/32 = 8 and (word_cnt mod 8) = 4 then
        SubWord_in <=  temp;
    else
        SubWord_in <=  temp(7 downto 0) & temp(31 downto 8);
    end if;
end process;


process(word)
begin
    for i in 0 to 10+(key_width-128)/32 loop
        output((i+1)*128-1 downto i*128) <= word(4*i+3) & word(4*i+2) & word(4*i+1) & word(4*i);
    end loop;
end process;



end Behavioral;
