import collections
import json
from os.path import dirname, abspath
import os

KEY_WIDTH_VALUE_array = (128,192,256)



path = dirname(dirname(abspath(__file__)))
print('path:', path)


for file_type in ['encryption','decryption']:
    for i in KEY_WIDTH_VALUE_array:
        with open('./eval/AES_testcases_' + str(i) + '.txt',"r") as testcase_file:
            testcase = testcase_file.read().split('\n')
            with open('./AES_reference_' + file_type + '_' + str(i) + '.txt','w') as reference_file:
                with open('./AES_key_' + file_type + '_' + str(i) + '.txt','w') as key_file:
                    with open('./AES_testcase_' + file_type + '_' + str(i) + '.txt','w') as Plaintext_file:
                        with open('./AES_task_' + str(i) + '.txt','w') as task_file:
                            for each in testcase:
                                each = each.split()
                                if each!=[]:
                                    if each[0]=='0' and file_type=='encryption':
                                        task_file.writelines('0'+'\n')
                                        Plaintext = int(each[1],16)
                                        Plaintext = '{:0128b}'.format(Plaintext)
                                        Cipherkey = int(each[2],16)
                                        if i == 128:
                                            Cipherkey = '{:0128b}'.format(Cipherkey)
                                        elif i == 192:
                                            Cipherkey = '{:0192b}'.format(Cipherkey)
                                        elif i == 256:
                                            Cipherkey = '{:0256b}'.format(Cipherkey)
                                        Ciphertext = int(each[3],16)
                                        Ciphertext = '{:0128b}'.format(Ciphertext)
                                        Plaintext_file.writelines(Plaintext+'\n')
                                        key_file.writelines(Cipherkey+'\n')
                                        reference_file.writelines(Ciphertext+'\n')
                                    elif each[0]=='1' and file_type=='decryption':
                                        task_file.writelines('1'+'\n')
                                        Plaintext = int(each[1],16)
                                        Plaintext = '{:0128b}'.format(Plaintext)
                                        Cipherkey = int(each[2],16)
                                        if i == 128:
                                            Cipherkey = '{:0128b}'.format(Cipherkey)
                                        elif i == 192:
                                            Cipherkey = '{:0192b}'.format(Cipherkey)
                                        elif i == 256:
                                            Cipherkey = '{:0256b}'.format(Cipherkey)
                                        Ciphertext = int(each[3],16)
                                        Ciphertext = '{:0128b}'.format(Ciphertext)
                                        Plaintext_file.writelines(Plaintext+'\n')
                                        key_file.writelines(Cipherkey+'\n')
                                        reference_file.writelines(Ciphertext+'\n')
                                    elif each[0]=='0' and file_type=='decryption':
                                        task_file.writelines('0'+'\n')
                                    
os.system("ghdl -a --ieee=synopsys --std=08 ./src/util_package.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 ./src/AddRoundKey.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 ./src/AES.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 ./src/Final_Round.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 ./src/Key_Expansion.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 ./src/MixColumns.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 ./src/Rounds.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 ./src/Sbox.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 ./src/ShiftRows.vhd")
os.system("ghdl -a --ieee=synopsys --std=08 ./src/SubBytes.vhd")

os.system("ghdl -a --ieee=synopsys --std=08 ./sim/testbench.vhd")
                
os.system("ghdl -e --ieee=synopsys --std=08 testbench")         
os.system("ghdl -r --ieee=synopsys --std=08 testbench --stop-time=1ms") 

os.system("cp ./AES_results_encryption_128.txt ./eval/AES_results_encryption_128.txt")
os.system("cp ./AES_results_encryption_192.txt ./eval/AES_results_encryption_192.txt")
os.system("cp ./AES_results_encryption_256.txt ./eval/AES_results_encryption_256.txt")
os.system("cp ./AES_results_decryption_128.txt ./eval/AES_results_decryption_128.txt")
os.system("cp ./AES_results_decryption_192.txt ./eval/AES_results_decryption_192.txt")
os.system("cp ./AES_results_decryption_256.txt ./eval/AES_results_decryption_256.txt")