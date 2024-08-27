section .data
    jmp_table:
        dq _instructionWithTowChar
        dq _instructionWithThreeChar
        dq _instructionWithFourChar
        dq _instructionWithFiveChar
        dq _instructionWithSixChar

section .text
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

    lea rdi, [rsp + 16 + 8]
    lea rsi, [zxPrefix]
    mov rcx, zxPrefixLen-1
    rep cmpsb
    je _chargeZxPrefix

    jmp _cantAssembly

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


    jmp _cantAssembly


_instructionWithFourChar:
    lea rdi, [rsp + 16 + 8]
    lea rsi, [nandInstruction]
    mov rcx, nandInstructionLen-1
    rep cmpsb
    je _assemblyNandInstruction

    jmp _cantAssembly


_instructionWithFiveChar:          ;compares with 5 character instructions
    lea rdi, [rsp + 16 + 8]
    lea rsi, [neverInstruction]
    mov rcx, neverInstructionLen-1
    rep cmpsb
    je _assemblyNeverInstruction

    jmp _cantAssembly

_instructionWithSixChar:          ;compares with 6 character instructions
    lea rdi, [rsp + 16 + 8]
    lea rsi, [alwaysInstruction]
    mov rcx, alwaysInstructionLen-1
    rep cmpsb
    je _assemblyAlwaysInstruction

    jmp _cantAssembly

_cantAssembly:
    mov rax, -1         ;return -1 it mean the instruction of currentline not exist
    ret

;[rsp + 16 + 8] = currentLine
;rdi = nb of char of the instruction of current line
;r8 second return value, it contain the id of the instruction was assembly
;rax return the assembly line
;if all is well, rdi containe current line without the instruction
_instructionLabelHandler:
    xor r8, r8
    ;switch statment
    mov rcx, rdi
    sub rcx, 2                      ;sub the value of the start (2) to set the firt index at 0
    cmp rcx, 4                      ;cmp with the total nb of case
    jae _cantAssembly               ;if the index is hender the jmpTable jmp to _cantAssembly

    jmp [jmp_table + rcx * 8]



;------------------------------------------------------------------

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

    ;allocate memore to store the binary in ascii 8 byte for the binary and 8 byte for the allignement and fill buffer with "0"
    sub rsp, assemblyArgSize
    lea rdi, [rsp]
    xor r8, r8
    call _fillBufferZero

    lea rdi, [rsp]
    mov rsi, 128                ;128 and not 32 because im mode have 00 for the tow MSB,U1 = 1; Un+1 = Un * 2; n = nb of bits you want to write, Un what you need to put in rsi
    call _nbToBin

    ;store the binary code in rax
    mov rax, [rsp]

    ;free the allocated memory
    add rsp, assemblyArgSize

    mov rsp, rbp
    pop rbp
    jmp _writeBinary


_fillBufferZero:
    cmp r8, assemblyArgSize
    jae _quit

    mov byte [rdi + r8], '0'

    inc r8
    jmp _fillBufferZero

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
    mov rdx, errorNbTooLargelen - 1
    syscall
    
    call _printSrcLineError

    ;give the first arg of _exitError
    mov rdi, 8
    jmp _exitError
;------------------------------------------------------------------
_replaceLabelToAddr:
    push rbp
    mov rbp, rsp

    cmp rax, 255
    ja _errorNbTooLargeLabel

    ;allocate memory to store the binary in ascii 8 byte for the binary and 8 byte for the allignement and fill buffer with "0"
    sub rsp, assemblyArgSize
    lea rdi, [rsp]
    xor r8, r8
    call _fillBufferZero

    lea rdi, [rsp]
    mov rsi, 128                ;128 to use 8 bits
    call _nbToBin

    ;store the binary code in rax
    mov rax, [rsp]

    ;free the allocated memory
    add rsp, assemblyArgSize

    mov rsp, rbp
    pop rbp
    jmp _writeBinary



_errorNbTooLargeLabel:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorNbTooLargeLabel
    mov rdx, errorNbTooLargeLabelLen - 1
    syscall 

    call _printSrcLineError

    mov rdi, 16
    call _exitError
;------------------------------------------------------------------


_assemblyMovArg:
    push rbp
    mov rbp, rsp

    ;check that the length of both arguments is correct 
    cmp word [rbp + 16 + 4], 1
    jne _argLengthError
    cmp word [rbp + 16 + 6], 1
    jne _argLengthError

    sub rsp, assemblyArgSize            ;allocate 8 bytes to store assembled arguments
    mov qword [rsp], 0                  ;set the buffer to 0 

    lea rsi, [rsp]                      ;set rsi the pointer for the buffer

    ;set Mov mode with rax
    mov word [rsi], ax                  ;mov byte [rsi], "1", inc rsi, mov byte [rsi], "0"
    inc rsi

    ;rdi containe currentLine without the instruction but you need to remove the space
    inc rdi                             ;remove the space
    add rsi, 3                          ;to write the firt arg on the least significant bits
    call _assemblyMovArgReg

    ;assemble the seconde register(destination)
    inc rdi                             ;remove the space
    sub rsi, 6                          ;write the second argument in the right place, -3 to avoid writing over the first argument, and again -3 to write over it's 3 bit.
    call _assemblyMovArgReg

    mov rax, [rsp]

    add rsp, assemblyArgSize            ;free the allocated memory

    mov rsp, rbp
    pop rbp
    jmp _writeBinary


_assemblyMovArgReg:
    mov al, byte [rdi]
    
    inc rdi         ;pass this register
    
    cmp al, 'a'
    je _assemblyRegA
    cmp al, 'c'
    je _assemblyRegC
    cmp al, 'd'
    je _assemblyRegD
    cmp al, 'r'
    je _assemblyRegR
    cmp al, 'f'
    je _assemblyRegF
    cmp al, 'x'
    je _assemblyRegX

    ;jump to message error
    jmp _argLengthError

_argLengthError:
    mov rax, 1 
    mov rdi, 1 
    mov rsi, errorInvalidReg 
    mov rdx, errorInvalidRegLen 
    syscall

    call _printSrcLineError

    mov rdi, 16                         ;save of rbp and rdi
    jmp _exitError