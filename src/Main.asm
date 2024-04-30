bits 64
global _start

%include "./src/File.asm"
%include "./src/ReadLine.asm"
%include "./src/GetNbChar.asm"

section .data
    hello db "start cloryys...", 10, 0
    helloLen equ $-hello

    errorFilePath db "error: please check if the file path is correct", 10, 0
    errorFilePathLen equ $-errorFilePath

    warnOverflow db "warn: an overflow has been avoided", 10, 0
    warnOverflowLen equ $-warnOverflow

    bufferSize equ 1024      ;1024 for the moment to be modified in the future
    currentLineSize equ 16
    nbOfCharSize equ 2*4+8   ;2*4 for the array and add 8 to align the stack

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

    mov rax, buffer
    jmp _mainLoop



_mainLoop:
    mov r9, [rax]
    cmp r9, 0      ;check if it end of file with the null byte
    je _exit

    ;clean the tow buffer currentLine and nbOfCharSize
    xor r8, r8
    lea rdi, [rsp]
    mov rsi, currentLineSize + nbOfCharSize
    call _cleanBuffer

    ;store the current line without storing unnecessary characters
    mov rdi, rax
    lea rsi, [rsp + 16]
    call _storeCurrentLine


    ;get nb of information (instruction/opéran/opérande)
    push rax
    lea rdi, [rsp + 8 + 16]
    mov rsi, r8
    call _getNbCurrentLineArg
    pop rax

    ;transcode currentLine
    ;wirte currentLineInFile

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

_exitError:
    mov rax, 60
    mov rdi, 1
    syscall

_exit:
    add rsp, currentLineSize

    mov rax, 60
    xor rdi, rdi
    syscall