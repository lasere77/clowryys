section .data
    jmp_table:
        dq _instructionWithTowChar
        dq _instructionWithThreeChar
        dq _instructionWithFourChar
        dq _instructionWithFiveChar
        dq _instructionWithSixChar
    ;instruction
    imInstruction db "im", 0
    imInstructionLen equ $-imInstruction

    orInstruction db "or", 0
    orInstructionLen equ $-orInstruction

    nandInstruction db "nand", 0
    nandInstructionLen equ $-nandInstruction

    norInstruction db "nor", 0
    norInstructionLen equ $-norInstruction

    andInstruction db "and", 0
    andInstructionLen equ $-andInstruction

    addInstruction db "add", 0
    addInstructionLen equ $-addInstruction

    subInstruction db "sub", 0
    subInstructionLen equ $-subInstruction

    movInstruction db "mov", 0
    movInstructionLen equ $-movInstruction

    neverInstruction db "never", 0
    neverInstructionLen equ $-neverInstruction

    jeInstruction db "je", 0
    jeInstructionLen equ $-jeInstruction

    jgInstruction db "jg", 0
    jgInstructionLen equ $-jgInstruction

    jgeInstruction db "jge", 0
    jgeInstructionLen equ $-jgeInstruction

    alwaysInstruction db "always", 0
    alwaysInstructionLen equ $-alwaysInstruction

    jneInstruction db "jne", 0
    jneInstructionLen equ $-jneInstruction

    jleInstruction db "jle", 0
    jleInstructionLen equ $-jleInstruction

    jlInstruction db "jl", 0
    jlInstructionLen equ $-jlInstruction

    nopInstruction db "nop", 0
    nopInstructionLen equ $-nopInstruction

    ;const ID instruction
    IDIm equ 0
    IDOr equ 1
    IDJe equ 2
    IDJg equ 3
    IDJl equ 4
    IDNor equ 5
    IDAnd equ 6
    IDAdd equ 7
    IDSub equ 8
    IDMov equ 9
    IDJge equ 10
    IDJne equ 11
    IDJle equ 12
    IDNop equ 13
    IDNand equ 14
    IDNever equ 15
    IDAlways equ 16

section .text
_assemblyImInstruction:
    mov rax, "00XXXXXX"
    mov r8, IDIm
    ret
_assemblyOrInstruction:
    mov rax, "01000000"
    mov r8, IDOr
    ret
_assemblyNandInstruction:
    mov rax, "01000001"
    mov r8, IDNand
    ret
_assemblyNorInstruction:
    mov rax, "01000010"
    mov r8, IDNor
    ret
_assemblyAndInstruction:
    mov rax, "01000011"
    mov r8, IDAnd
    ret
_assemblyAddInstruction:
    mov rax, "01000100"
    mov r8, IDAdd
    ret
_assemblySubInstruction:
    mov rax, "01000101"
    mov r8, IDSub
    ret
_assemblyMovInstruction:
    mov rax, "10XXXXXX"
    mov r8, IDMov
    ret
_assemblyNeverInstruction:
    mov rax, "11000000"
    mov r8, IDNever
    ret
_assemblyJeInstruction:
    mov rax, "11000001"
    mov r8, IDJe
    ret
_assemblyJgInstruction:
    mov rax, "11000111"
    mov r8, IDJg
    ret
_assemblyJgeInstruction:
    mov rax, "11000110"
    mov r8, IDJge
    ret
_assemblyAlwaysInstruction:
    mov rax, "11000100"
    mov r8, IDAlways
    ret
_assemblyJneInstruction:
    mov rax, "11000101"
    mov r8, IDJne
    ret
_assemblyJleInstruction:
    mov rax, "11000011"
    mov r8, IDJle
    ret
_assemblyJlInstruction:
    mov rax, "11000010"
    mov r8, IDJl
    ret
_assemblyNopInstruction:
    mov rax, "11000000"
    mov r8, IDNop
    ret

;---------------------------------------------
_instructionWithTowChar:       ;compares with 2 character instructions
    lea rdi, [rsp + 16 + 8]
    lea rsi, [imInstruction]
    mov rcx, imInstructionLen-1
    rep cmpsb
    je _assemblyImInstruction

    lea rdi, [rsp + 16 + 8]
    lea rsi, [orInstruction]
    mov rcx, orInstructionLen-1
    rep cmpsb
    je _assemblyOrInstruction


    lea rdi, [rsp + 16 + 8]
    lea rsi, [jeInstruction]
    mov rcx, jeInstructionLen-1
    rep cmpsb
    je _assemblyJeInstruction


    lea rdi, [rsp + 16 + 8]
    lea rsi, [jgInstruction]
    mov rcx, jgInstructionLen-1
    rep cmpsb
    je _assemblyJgInstruction


    lea rdi, [rsp + 16 + 8]
    lea rsi, [jlInstruction]
    mov rcx, jlInstructionLen-1
    rep cmpsb
    je _assemblyJlInstruction

    jmp _instructionNotExist

_instructionWithThreeChar:          ;compares with 3 character instructions
    lea rdi, [rsp + 16 + 8]
    lea rsi, [movInstruction]
    mov rcx, movInstructionLen-1
    rep cmpsb
    je _assemblyMovInstruction

    lea rdi, [rsp + 16 + 8]
    lea rsi, [addInstruction]
    mov rcx, addInstructionLen-1
    rep cmpsb
    je _assemblyAddInstruction

    lea rdi, [rsp + 16 + 8]
    lea rsi, [subInstruction]
    mov rcx, subInstructionLen-1
    rep cmpsb
    je _assemblySubInstruction


    lea rdi, [rsp + 16 + 8]
    lea rsi, [norInstruction]
    mov rcx, norInstructionLen-1
    rep cmpsb
    je _assemblyNorInstruction

    lea rdi, [rsp + 16 + 8]
    lea rsi, [andInstruction]
    mov rcx, andInstructionLen-1
    rep cmpsb
    je _assemblyAndInstruction

    lea rdi, [rsp + 16 + 8]
    lea rsi, [jneInstruction]
    mov rcx, jneInstructionLen-1
    rep cmpsb
    je _assemblyJneInstruction

    lea rdi, [rsp + 16 + 8]
    lea rsi, [jgeInstruction]
    mov rcx, jgeInstructionLen-1
    rep cmpsb
    je _assemblyJgeInstruction

    lea rdi, [rsp + 16 + 8]
    lea rsi, [jleInstruction]
    mov rcx, jleInstructionLen-1
    rep cmpsb
    je _assemblyJleInstruction

    lea rdi, [rsp + 16 + 8]
    lea rsi, [nopInstruction]
    mov rcx, nopInstructionLen-1
    rep cmpsb
    je _assemblyNopInstruction


    jmp _instructionNotExist


_instructionWithFourChar:
    lea rdi, [rsp + 16 + 8]
    lea rsi, [nandInstruction]
    mov rcx, nandInstructionLen-1
    rep cmpsb
    je _assemblyNandInstruction

    jmp _instructionNotExist


_instructionWithFiveChar:          ;compares with 5 character instructions
    lea rdi, [rsp + 16 + 8]
    lea rsi, [neverInstruction]
    mov rcx, neverInstructionLen-1
    rep cmpsb
    je _assemblyNeverInstruction

    jmp _instructionNotExist

_instructionWithSixChar:          ;compares with 6 character instructions
    lea rdi, [rsp + 16 + 8]
    lea rsi, [alwaysInstruction]
    mov rcx, alwaysInstructionLen-1
    rep cmpsb
    je _assemblyAlwaysInstruction

    jmp _instructionNotExist

_instructionNotExist:
    mov rax, -1         ;return -1 it mean the instruction of currentline not exist
    ret

;[rsp + 16 + 8] = currentLine
;rdi = nb of char of the instruction of current line
;r8 second return value, it contain the id of the instruction was assembly
;rax return the assembly line
;if all is well, rdi containe current line without the instruction
_assemblyInstruction:
    xor r8, r8
    ;switch statment
    mov rcx, rdi
    sub rcx, 2                      ;sub the value of the start (2) to set the firt index at 0
    cmp rcx, 4                      ;cmp with the total nb of case
    jae _instructionNotExist        ;if the index is hender the jmpTable jmp to _instructionNotExist

    jmp [jmp_table + rcx * 8]


_assemblyImArg:
    push rbp
    mov rbp, rsp

    ;rdi containe currentLine without the instruction but you need to remove the space
    inc rdi             ;remove the space
    xor r8, r8
    xor r9, r9
    xor rax, rax
    call _atoi

    ;check if nb > 63
    cmp rax, 63
    ja _errorNbTooLarge

    ;allocate memore to store the binary in ascii 8 byte for the binary and 8 byte for the allignement 
    sub rsp, 16
    lea rdi, [rsp]
    mov rsi, 16
    xor r8, r8
    call _cleanBuffer

    lea rdi, [rsp + 8]
    mov rsi, 128                ;128 and not 32 because im mode have 00 for the tow MSB,U1 = 1; Un+1 = Un * 2; n = nb of bits you want to write, Un what you need to put in rsi
    call _nbToBin

    ;store the binary code in rax
    mov rax, [rdi - 8]

    ;free the allocated memory
    add rsp, 16

    mov rsp, rbp
    pop rbp
    jmp _writeBinary


_itZero:
    mov byte [rdi], '0'

    ;div by tow rsi
    shr rsi, 1

    inc rdi
    jmp _nbToBin

;rax nb to convert
;rdi buffer
;rsi value to divice
_nbToBin:
    cmp rax, 0
    je _quit

    cmp rax, rsi
    jl _itZero

    mov byte [rdi], '1'
    sub rax, rsi

    ;div by tow rsi
    shr rsi, 1

    inc rdi
    jmp _nbToBin

_itCharNotNb:
    inc r9       ;pass this char

    ;check if it's a negative sign ('-' -> 45 but - 48 = -3)  
    cmp r8, -3
    je _errorNbTooLarge

    jmp _atoi

_atoi:
    ;check if r9 >= lenght of the seconde arg
    cmp r9w, word [rbp + 16 + 4]
    jae _quit

    movzx r8, byte [rdi + r9]

    ;ascii to int
    sub r8, 48
    ;check if it's a number
    cmp r8, 9
    ja _itCharNotNb

    ;multiplie the rax by 10 and add the new number
    imul rax, rax, 10
    add rax, r8

    inc r9
    jmp _atoi

_errorNbTooLarge:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorNbTooLarge
    mov rdx, errorNbTooLargelen
    syscall
    
    ;give the first arg of _exitError
    mov rdi, 8
    jmp _exitError