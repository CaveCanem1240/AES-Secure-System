library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
package util_package is    
    function clog2 (x : POSITIVE) return POSITIVE;
    function maximum(x : INTEGER; y : INTEGER) return INTEGER;
    function minimum(x : INTEGER; y : INTEGER) return INTEGER;
    function get_valid_kind(array_size : POSITIVE; matrix_line : POSITIVE) return POSITIVE;
    function RC(i : integer) return std_logic_vector;
    -- Add your own code here
end util_package;

package body util_package is

function clog2 (x : POSITIVE) return POSITIVE is
    variable i : POSITIVE;
begin
    i := 1;  
    while (2**i < x) and i < 31 loop
        i := i + 1;
    end loop;
    return i;
end function;

function maximum(x : INTEGER; y : INTEGER) return INTEGER is
    variable z : INTEGER;
begin
    if x > y then
        z := x;
    else
        z := y;
    end if;
    return z;
end function;

function minimum(x : INTEGER; y : INTEGER) return INTEGER is
    variable z : INTEGER;
begin
    if x > y then
        z := y;
    else
        z := x;
    end if;
    return z;
end function;

function get_valid_kind(array_size : POSITIVE; matrix_line : POSITIVE) return POSITIVE is
    variable i : POSITIVE;
begin
    i := 1;
    while (matrix_line*i < 2*array_size-1) and i < 31 loop
        i := i + 1;
    end loop;
    return i;
end function;

-- Add your own code here

function RC(i : integer) return std_logic_vector is
    variable temp : std_logic_vector(7 downto 0):=(others => '0');
begin
--    if i = 1 then
--        return std_logic_vector(to_unsigned(1,8));
--    else
--        temp := std_logic_vector(to_unsigned(1,8));
--        for j in 2 to i loop
--            temp := (temp(6 downto 0) & "0") xor ("000" & temp(7) & temp(7) & "0" & temp(7) & temp(7));
--        end loop;
--        return temp;
--    end if;
    case i is
    when 1 => return x"01";
    when 2 => return x"02";
    when 3 => return x"04";
    when 4 => return x"08";
    when 5 => return x"10";
    when 6 => return x"20";
    when 7 => return x"40";
    when 8 => return x"80";
    when 9 => return x"1b";
    when 10 => return x"36";
    when 11 => return x"6C";
    when 12 => return x"D8";
    when 13 => return x"AB";
    when 14 => return x"4D";
    when others =>  null;
    end case;
end function;

end package body util_package;