import os
import regex as re

R_types = ['SLL', 'SRL', 'SRA', 'ADD', 'SUB', 'AND', 'OR', 'XOR', 'SLT', 'SLTU']
I_types = ['ADDI', 'SLTI', 'ANDI', 'ORI', 'XORI', 'LOAD_WORD', 'STORE_WORD']
B_types = ['J', 'BEQ', 'BNEQ']

opcodes = dict([('R_INSTR' ,'000000'),
('ADDI','001000'),
('SLTI', '001010'),
('ANDI', '001100'),
('ORI', '001101'),
('XORI', '001110'),
('LOAD_WORD', '100011'),
('STORE_WORD', '101011'),
('J', '000010'),
('BEQ', '000100'),
('BNEQ', '000101') ])

functs = dict([('FUNCT_SLL', '000000'),
 ('FUNCT_SRL', '000010'),
 ('FUNCT_SRA', '000011'),
 ('FUNCT_ADD', '100000'),
 ('FUNCT_SUB', '100010'),
 ('FUNCT_AND', '100100'),
 ('FUNCT_OR', '100101'),
 ('FUNCT_XOR', '100110'),
 ('FUNCT_SLT', '101010'),
 ('FUNCT_SLTU', '101011')])

def extract_arguments( instruction ):
    arguments = re.split('[,\s]', instruction)
    arguments = [argument for argument in arguments if argument is not '']
    if len(arguments)<4:
        arguments = arguments + (4-len(arguments))*['']
    return arguments

def binary(number, bits):
    
    original = number
    
    if number == 0:
        return bits*'0'
    
    if number<0:
        temp = bits
        while number< -(2**(temp-1)):       # negative overflow
            temp+=1
        number = 2**temp + number           # This is the unsigned equivalent of the negative number
        
    string = ''
    
    while number!= 0:
        string = string+str(number%2)
        number = number//2
        
    string = string[::-1] # reversing the string 

        
    if bits<len(string):
        string = string[-bits:]
    else:
        extra = bits-len(string)
        prefix = extra*'0' if original>=0 else extra*'1'
        string = prefix+string
    
    overflow = False if -(2**(bits-1))<=original<=(2**(bits-1)-1) else True
    return string

def encode_reg(reg):
    
    '''This function takes input in the form of r/$ x, where x is the register number. 
    Register numbers can range from 0-31. In case of an out of scope register, an execption is thrown.
    Output is in the form of a binary string.'''
    
    number = int(re.split('[r$]', reg)[1])
    return binary(number,5)


def encode(instruction):
    
    arguments = extract_arguments(instruction)
    command = arguments[0].upper()
    dreg = encode_reg(arguments[1])
    sreg = encode_reg(arguments[2])
    regorimm = arguments[3]
    
    if command in R_types:
        
        opcode = opcodes['R_INSTR']
        funct = functs['FUNCT_'+command]
        if 'FUNCT_'+command in ['FUNCT_SLL', 'FUNCT_SRL', 'FUNCT_SRA']:
            
            shamt = binary(int(regorimm),5)
            result = opcode+sreg+'00000'+dreg+shamt+funct
        else:
            
            shamt = '00000'
            result = opcode+sreg+encode_reg(regorimm)+dreg+shamt+funct
            
    elif command in I_types:
        
        opcode = opcodes[command]
        immediate = binary(int(regorimm), 16)
        
        result = opcode+sreg+dreg+immediate
        
    elif command in B_types:
        
        opcode = opcodes[command]
        if command is 'J':
            immediate = binary(int(arguments[1]), 26)
            result = opcode + immediate
        else:
            immediate = binary(int(regorimm),16)
            result = opcode + sreg + dreg + immediate  # there is no desination, dreg is actually the 2nd operand.
            
    else: 
        print(f"{command.upper()} is not a command that is available in the ISA. Please modify the code" )
        quit()

    return result

################################################### Script starts here ################################################################  

with open('program.asm', mode = 'r') as file:
    program = file.read()
    
program = program.split('\n')
program = program[:program.index('')]


enc_intr = []

for instruction in program:
    enc_intr.append(encode(instruction)) 

memory = []
for instruction in enc_intr:
    split = [instruction[:8]+'\n', instruction[8:16]+'\n', instruction[16:24]+'\n', instruction[24:32]+'\n']
    memory = memory + split
    
with open('instruction.memory', mode = 'w') as file:
    file.writelines(memory)