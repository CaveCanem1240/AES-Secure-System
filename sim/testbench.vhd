----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2020/12/07 01:34:41
-- Design Name: 
-- Module Name: testbench - Behavioral
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
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench is
--  Port ( );
--    Generic (
--           input_width : positive:=128;
--           key_width : positive:=128
--           );
end testbench;

architecture Behavioral of testbench is
component AES is
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
end component;
signal clk,rst: STD_LOGIC:='0';

signal new_key,key_exp_done_sig: STD_LOGIC:='0';
signal input_mat : std_logic_vector(128-1 downto 0) := (others => '0');
signal output_sig : std_logic_vector(127 downto 0):= (others => '0');
signal output_done_sig,load_key : STD_LOGIC:='0';

signal new_key_192,key_exp_done_sig_192: STD_LOGIC:='0';
signal input_mat_192 : std_logic_vector(191 downto 0) := (others => '0');
signal output_sig_192 : std_logic_vector(127 downto 0):= (others => '0');
signal output_done_sig_192,load_key_192 : STD_LOGIC:='0';

signal new_key_256,key_exp_done_sig_256: STD_LOGIC:='0';
signal input_mat_256 : std_logic_vector(255 downto 0) := (others => '0');
signal output_sig_256 : std_logic_vector(127 downto 0):= (others => '0');
signal output_done_sig_256,load_key_256 : STD_LOGIC:='0';

begin

gen_clk:
    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

uut128:AES 
        generic map(input_width=>128,key_width=>128)
        port map(clk=>clk,rst=>rst,input=>input_mat,load_key=>load_key,new_key=>new_key,key_exp_done=>key_exp_done_sig,output=>output_sig,output_done=>output_done_sig);
uut192:AES 
        generic map(input_width=>128,key_width=>192)
        port map(clk=>clk,rst=>rst,input=>input_mat_192,load_key=>load_key_192,new_key=>new_key_192,key_exp_done=>key_exp_done_sig_192,output=>output_sig_192,output_done=>output_done_sig_192);
uut256:AES 
        generic map(input_width=>128,key_width=>256)
        port map(clk=>clk,rst=>rst,input=>input_mat_256,load_key=>load_key_256,new_key=>new_key_256,key_exp_done=>key_exp_done_sig_256,output=>output_sig_256,output_done=>output_done_sig_256);

---------------------------------------------------------------------------------------------------------
--128
---------------------------------------------------------------------------------------------------------
    read_input: process
        FILE testcase_file_in,key_file_in: text;
        variable file_status: file_open_status;
        variable buf: line;
        variable data_testcase: STD_LOGIC_VECTOR(127 downto 0);
        variable data_key: STD_LOGIC_VECTOR(128-1 downto 0);
    begin
        file_open(file_status, testcase_file_in, "AES_testcase_encryption_128.txt", read_mode);
        file_open(file_status, key_file_in, "AES_key_encryption_128.txt", read_mode);
        
        while not endfile(key_file_in) loop
            readline(key_file_in, buf);
            read(buf, data_key);
            input_mat(128-1 downto 0) <= data_key;
            load_key <= '1';
            wait until rising_edge(clk);
            load_key <= '0';
            new_key <= '1';
            wait until rising_edge(clk);
            new_key <= '0';
            wait until rising_edge(key_exp_done_sig);
            readline(testcase_file_in, buf);
            read(buf, data_testcase);
            input_mat(127 downto 0) <= data_testcase;
            wait until rising_edge(output_done_sig);
        end loop;
        wait;
    end process read_input;

    check_result: process
        file file_out,file_out1,reference_file_in,task_file_in: TEXT;
        variable file_status: file_open_status;
        variable buf: LINE;
        variable task: STD_LOGIC;
        variable data_reference: STD_LOGIC_VECTOR(127 downto 0);
    begin
        file_open(file_out, "AES_results_encryption_128.txt", write_mode);
        file_open(file_out1, "AES_outputs_encryption_128.txt", write_mode);
        file_open(file_status, reference_file_in, "AES_reference_encryption_128.txt", read_mode);
        file_open(file_status, task_file_in, "AES_task_128.txt", read_mode);
        while not endfile(task_file_in) loop
            readline(task_file_in, buf);
            read(buf, task);
            if task = '1' then
                write(buf, 'N');
                writeline(file_out,buf);
            elsif task = '0' then
                readline(reference_file_in, buf);
                read(buf, data_reference);
                wait until rising_edge(output_done_sig);
                write(buf, output_sig);
                writeline(file_out1,buf);
                if data_reference = output_sig then
                    write(buf, 'P');
                else
                    write(buf, 'F');
                end if;
                writeline(file_out,buf);
            end if;
        end loop;
        wait until falling_edge(output_done_sig);
        file_close(file_out);
        file_close(file_out1);
        wait;
        --std.env.finish;
    end process check_result;
---------------------------------------------------------------------------------------------------------  
--192
---------------------------------------------------------------------------------------------------------
    read_input_192: process
        FILE testcase_file_in_192,key_file_in_192: text;
        variable file_status: file_open_status;
        variable buf: line;
        variable data_testcase: STD_LOGIC_VECTOR(127 downto 0);
        variable data_key: STD_LOGIC_VECTOR(192-1 downto 0);
    begin
        file_open(file_status, testcase_file_in_192, "AES_testcase_encryption_192.txt", read_mode);
        file_open(file_status, key_file_in_192, "AES_key_encryption_192.txt", read_mode);
        
        while not endfile(key_file_in_192) loop
            readline(key_file_in_192, buf);
            read(buf, data_key);
            input_mat_192(192-1 downto 0) <= data_key;
            load_key_192 <= '1';
            wait until rising_edge(clk);
            load_key_192 <= '0';
            new_key_192 <= '1';
            wait until rising_edge(clk);
            new_key_192 <= '0';
            wait until rising_edge(key_exp_done_sig_192);
            readline(testcase_file_in_192, buf);
            read(buf, data_testcase);
            input_mat_192(127 downto 0) <= data_testcase;
            wait until rising_edge(output_done_sig_192);
        end loop;
        wait;
    end process read_input_192;

    check_result_192: process
        file file_out_192,file_out1_192,reference_file_in_192,task_file_in_192: TEXT;
        variable file_status: file_open_status;
        variable buf: LINE;
        variable task: STD_LOGIC;
        variable data_reference: STD_LOGIC_VECTOR(127 downto 0);
    begin
        file_open(file_out_192, "AES_results_encryption_192.txt", write_mode);
        file_open(file_out1_192, "AES_outputs_encryption_192.txt", write_mode);
        file_open(file_status, reference_file_in_192, "AES_reference_encryption_192.txt", read_mode);
        file_open(file_status, task_file_in_192, "AES_task_192.txt", read_mode);
        while not endfile(task_file_in_192) loop
            readline(task_file_in_192, buf);
            read(buf, task);
            if task = '1' then
                write(buf, 'N');
                writeline(file_out_192,buf);
            elsif task = '0' then
                readline(reference_file_in_192, buf);
                read(buf, data_reference);
                wait until rising_edge(output_done_sig_192);
                write(buf, output_sig_192);
                writeline(file_out1_192,buf);
                if data_reference = output_sig_192 then
                    write(buf, 'P');
                else
                    write(buf, 'F');
                end if;
                writeline(file_out_192,buf);
            end if;
        end loop;
        wait until falling_edge(output_done_sig_192);
        file_close(file_out_192);
        file_close(file_out1_192);
        wait;
        --std.env.finish;
    end process check_result_192;
---------------------------------------------------------------------------------------------------------  
--256
---------------------------------------------------------------------------------------------------------
    read_input_256: process
        FILE testcase_file_in_256,key_file_in_256: text;
        variable file_status: file_open_status;
        variable buf: line;
        variable data_testcase: STD_LOGIC_VECTOR(127 downto 0);
        variable data_key: STD_LOGIC_VECTOR(256-1 downto 0);
    begin
        file_open(file_status, testcase_file_in_256, "AES_testcase_encryption_256.txt", read_mode);
        file_open(file_status, key_file_in_256, "AES_key_encryption_256.txt", read_mode);
        
        while not endfile(key_file_in_256) loop
            readline(key_file_in_256, buf);
            read(buf, data_key);
            input_mat_256(256-1 downto 0) <= data_key;
            load_key_256 <= '1';
            wait until rising_edge(clk);
            load_key_256 <= '0';
            new_key_256 <= '1';
            wait until rising_edge(clk);
            new_key_256 <= '0';
            wait until rising_edge(key_exp_done_sig_256);
            readline(testcase_file_in_256, buf);
            read(buf, data_testcase);
            input_mat_256(127 downto 0) <= data_testcase;
            wait until rising_edge(output_done_sig_256);
        end loop;
        wait;
    end process read_input_256;

    check_result_256: process
        file file_out_256,file_out1_256,reference_file_in_256,task_file_in_256: TEXT;
        variable file_status: file_open_status;
        variable buf: LINE;
        variable task: STD_LOGIC;
        variable data_reference: STD_LOGIC_VECTOR(127 downto 0);
    begin
        file_open(file_out_256, "AES_results_encryption_256.txt", write_mode);
        file_open(file_out1_256, "AES_outputs_encryption_256.txt", write_mode);
        file_open(file_status, reference_file_in_256, "AES_reference_encryption_256.txt", read_mode);
        file_open(file_status, task_file_in_256, "AES_task_256.txt", read_mode);
        while not endfile(task_file_in_256) loop
            readline(task_file_in_256, buf);
            read(buf, task);
            if task = '1' then
                write(buf, 'N');
                writeline(file_out_256,buf);
            elsif task = '0' then
                readline(reference_file_in_256, buf);
                read(buf, data_reference);
                wait until rising_edge(output_done_sig_256);
                write(buf, output_sig_256);
                writeline(file_out1_256,buf);
                if data_reference = output_sig_256 then
                    write(buf, 'P');
                else
                    write(buf, 'F');
                end if;
                writeline(file_out_256,buf);
            end if;
        end loop;
        wait until falling_edge(output_done_sig_256);
        file_close(file_out_256);
        file_close(file_out1_256);
        wait;
        --std.env.finish;
    end process check_result_256;
---------------------------------------------------------------------------------------------------------  
    process
        file file_out2: TEXT;
    begin
        file_open(file_out2, "AES_results_decryption_128.txt", write_mode);
        file_close(file_out2);
        file_open(file_out2, "AES_results_decryption_192.txt", write_mode);
        file_close(file_out2);
        file_open(file_out2, "AES_results_decryption_256.txt", write_mode);
        file_close(file_out2);

        wait until falling_edge(output_done_sig);
    end process;

    process
    begin
    wait for 1 ms;
    std.env.finish;
    end process;



end Behavioral;
