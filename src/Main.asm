bits 64
global _start

%include "./src/File.asm"
%include "./src/ReadLine.asm"
%include "./src/GetNbChar.asm"
%include "./src/Assembler.asm"
%include "./src/RefAssembler.asm"

section .data
    ;message
    hello db "start cloryys...", 10, 0
    helloLen equ $-hello

    errorFilePath db "error: please check if the file path is correct", 10, 0
    errorFilePathLen equ $-errorFilePath

    warnOverflow db "warn: an overflow has been avoided", 10, 0
    warnOverflowLen equ $-warnOverflow

    errorUnknownInstruction db "error: instruction not referenced, it doesn't exist", 10, 0
    errorUnknownInstructionLen equ $-errorUnknownInstruction

    errorNbTooLarge db "error: the nomber you give to the im instruction is too large, please check the nb is an integer in the interval [0;63]", 10, 0
    errorNbTooLargelen equ $-errorNbTooLarge

    errorInvalidReg db "error: invalid register", 10, 0
    errorInvalidRegLen equ $-errorInvalidReg

    ;const
    bufferSize equ 1024      ;1024 for the moment to be modified in the future
    currentLineSize equ 16
    nbOfCharSize equ 2*4+8   ;2*4 for the array and add 8 to align the stack
    assemblyArgSize equ 8 

section .bss
    buffer resb bufferSize

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, hello
    mov rdx, helloLen
    syscall

    ;openFile with argv[1]
    call _openFile

    ;check if the file is correctly opened
    cmp rax, 0
    jl _errorFilePath
    
    call _readFile
    call _closeFile

    ;buffer for countain currenteline
    ;stores the line who need to transcode in to binary, 16 byte was allocated
    sub rsp, currentLineSize
    lea rax, [rsp]
    ;allocate memory to store nb of arg are in currentLine and nb of char for each arg
    sub rsp, nbOfCharSize

    mov r15, buffer
    jmp _mainLoop



_mainLoop:
    mov r9, [r15]
    cmp r9, 0      ;check if it end of file with the null byte
    je _exit

    ;clean the tow buffer currentLine and nbOfCharSize
    xor r8, r8
    lea rdi, [rsp]
    mov rsi, currentLineSize + nbOfCharSize
    call _cleanBuffer

    ;store the current line without storing unnecessary characters
    mov rdi, r15
    lea rsi, [rsp + 16]
    call _storeCurrentLine
    mov r15, rax
    ;if r8 = 0 nothing are store so you can passe to the next line
    cmp r8, 0
    je _mainLoop

    ;get nb of information (instruction/opéran/opérande)
    lea rdi, [rsp + 16]
    mov rsi, r8
    lea rdx, [rsp + 8]
    call _getNbCurrentLineArg

    ;transcode the instruction of currentLine
    movzx rdi, word [rsp + 8 + 2]          ;gives the number of characters in the current instruction
    call _assemblyInstruction
    ;check if the current line contains the correct instruction if not, exit the program with error code
    cmp rax, -1
    je _UnknownInstruction

    ;check if only the instruction assembly is required if this is true, write it to the binary file otherwise assemble the other arg in currentLine 
    cmp byte [rsp + 8], 1
    je _writeBinary
    cmp byte [rsp + 8], 2
    je _assemblyLineWithTowArg
    cmp byte [rsp + 8], 3
    je _assemblyLineWithThreeArg

    jmp _mainLoop

_assemblyLineWithTowArg:
    ;please do swith statment if you have more instruction here
    cmp r8, IDIm
    je _assemblyImArg

    ;exit with an error if the instruction was not referenced, the program should have aborted before this happened...
    jmp _UnknownInstruction


_assemblyLineWithThreeArg:
    cmp r8, IDMov
    je _assemblyMovArg

    jmp _writeBinary

_writeBinary:
    jmp _mainLoop



;set all bytes of the buffer to 0
;rdi = buffer to clean
;rsi = lenght of buffer (8*x !!!)
_cleanBuffer:
    cmp r8, rsi
    je _quit

    mov qword [rdi + r8], 0

    add r8, 8
    jmp _cleanBuffer

_quit:
    ret

_UnknownInstruction:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorUnknownInstruction
    mov rdx, errorUnknownInstructionLen
    syscall

    xor rdi, rdi
    jmp _exitError


;attention !!! be sure to set the right value at rdi !!! 
;rdi = nb of space has been allocated for the function, and its contents
_exitError:
    ;remove local var, save of rip/rsp...
    add rsp, rdi
    ;remove local var of the main fonction
    add rsp, currentLineSize + nbOfCharSize

    mov rax, 60
    mov rdi, 1
    syscall

_exit:
    add rsp, currentLineSize + nbOfCharSize

    mov rax, 60
    xor rdi, rdi
    syscall