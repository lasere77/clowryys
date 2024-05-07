section .data
    jmp_table:
        dq _instructionWithTowChar
        dq _instructionWithThreeChar
        dq _instructionNotExist
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

section .text
_assemblyImInstruction:
    mov rax, "00XXXXXX"
    ret
_assemblyOrInstruction:
    mov rax, "01000000"
    ret
_assemblyNandInstruction:
    mov rax, "01000001"
    ret
_assemblyNorInstruction:
    mov rax, "01000010"
    ret
_assemblyAndInstruction:
    mov rax, "01000011"
    ret
_assemblyAddInstruction:
    mov rax, "01000100"
    ret
_assemblySubInstruction:
    mov rax, "01000101"
    ret
_assemblyMovInstruction:
    mov rax, "10XXXXXX"
    ret
_assemblyNeverInstruction:
    mov rax, "11000000"
    ret
_assemblyJeInstruction:
    mov rax, "11000001"
    ret
_assemblyJgInstruction:
    mov rax, "11000111"
    ret
_assemblyJgeInstruction:
    mov rax, "11000110"
    ret
_assemblyAlwaysInstruction:
    mov rax, "11000100"
    ret
_assemblyJneInstruction:
    mov rax, "11000101"
    ret
_assemblyJleInstruction:
    mov rax, "11000011"
    ret
_assemblyJlInstruction:
    mov rax, "11000010"
    ret
_assemblyNopInstruction:
    mov rax, "11000000"
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
    lea rsi, [nandInstruction]
    mov rcx, nandInstructionLen-1
    rep cmpsb
    je _assemblyNandInstruction

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
;rax return the assembly line
;r8 second return value if r8 = 0 the entire line is assembled otherwise only the instruction is assembled
_assemblyInstruction:
    ;switch statment
    mov rcx, rdi
    sub rcx, 2                      ;sub the value of the start (2) to set the firt index at 0
    cmp rcx, 4                      ;cmp with the total nb of case
    jae _instructionNotExist        ;if the index is hender the jmpTable jmp to _instructionNotExist

    jmp [jmp_table + rcx * 8]