# Clowryys
assembler for the "OVERTURE" architecture. 

---
## Clowryys information
This program is an assembler for the "OVERTURE" architecture.
This program is very useful if you don't want to program this computer in binary, 
because with this assembler you can program it in assembly language and not use too many instructions to move a value from one register to another,
because here you can do the same thing but with just one instruction and two arguments.

## the computer associated with this architecture
- [Novarys](https://github.com/lasere77/Novarys)

## Credits

made by lasere77 


## compile
**the sources are compiled :**
with nasm you can use the Makefile
it work on linux

---
## how to program it?

### instruction

copy:

    mov destination, source

    im nomber

alu:

    add

    sub

    nor

    and

    or 

    nand

condition:

    je

    jne 

    ja ;unsigned

    jb ;unsigned

    jae ;unsigned

    jbe ;unsigned

    jg ;signed
    
    jl ;signed

    jge ;signed
    
    jle ;signed

    always

    never

other:

    nop

### label
Here, labels are the starting point for a conditional jump.
After the jump, it is not possible to return to the call from an instruction.

### how to assemble the clowryys code?
simply pass the path of your clowryys code as an argument to the clorwyys assembly and the job's done. 
and the binary file will be returned in ./bin with the name "binary.nova".

---
## precision
warning on a line you can only make one instruction accompanied by this argument if necessary  
If you want to write a comment, you can use semicolon  
alu instuction dont need arg, it take nomber in C and D and the result is return on R exemple sub is equal to C - D -> R  
mov is an instruction for mov the value of register on an other for exemple: mov A, R here you move R to A  
im is an instuction to put nomber on A but this number is in [0;63] interval  
the conditions will be interpreted according to the register R  
je equal to 0  
jne not equal to 0
jae/jge above or equal 0  
jbe/jle below or equal 0  
ja/jg above 0  
jb/jl below 0  
always true  
nerver false  
the nop instruction does nothing  