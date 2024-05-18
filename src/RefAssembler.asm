section .data
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
    mov rax, "00"
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
    mov rax, "10"
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

;------------------------------------------------------------------------

_assemblyRegA:
    inc rsi
    mov byte [rsi], "0"
    inc rsi
    mov byte [rsi], "0"
    inc rsi
    mov byte [rsi], "0"
    ret

_assemblyRegC:
    inc rsi
    mov byte [rsi], "0"
    inc rsi
    mov byte [rsi], "0"
    inc rsi
    mov byte [rsi], "1"
    ret
_assemblyRegD:
    inc rsi
    mov byte [rsi], "0"
    inc rsi
    mov byte [rsi], "1"
    inc rsi
    mov byte [rsi], "0"
    ret
_assemblyRegR:
    inc rsi
    mov byte [rsi], "0"
    inc rsi
    mov byte [rsi], "1"
    inc rsi
    mov byte [rsi], "1"
    ret
_assemblyRegF:
    inc rsi
    mov byte [rsi], "1"
    inc rsi
    mov byte [rsi], "0"
    inc rsi
    mov byte [rsi], "0"
    ret
_assemblyRegX:
    inc rsi
    mov byte [rsi], "1"
    inc rsi
    mov byte [rsi], "0"
    inc rsi
    mov byte [rsi], "1"
    ret

