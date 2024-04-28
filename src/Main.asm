bits 64
global _start

%include "./src/File.asm"
%include "./src/ReadLine.asm"

section .data
    hello db "start cloryys...", 10, 0
    helloLen equ $-hello

    errorFilePath db "error: please check if the file path is correct", 10, 0
    errorFilePathLen equ $-errorFilePath

    warnOverflow db "warn: an overflow has been avoided", 10, 0
    warnOverflowLen equ $-warnOverflow

    bufferSize equ 1024      ;1024 for the moment to be modified in the future
    currentLineSize equ 16

section .bss
    buffer resb bufferSize
    ;instruction resb 6                     ;memorizes the instruction just read

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

    mov rax, buffer
    jmp _mainLoop



_mainLoop:
    mov r9, [rax]
    cmp r9, 0      ;check if it end of file with the null byte
    je _exit

    ;clean currenteline buffer (set all bytes of the buffer to 0)
    xor r8, r8
    lea rdi, [rsp]
    mov rsi, currentLineSize
    call _cleanBuffer

    ;store the current line without storing unnecessary characters
    mov rdi, rax
    lea rsi, [rsp]
    call _storeCurrentLine


    ;get nb of information (instruction/opéran/opérande)
    push rax
    lea rdi, [rsp + 8]
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



_hidenChar:
    cmp r9, rsi
    je _quit

    mov al, [rdi + r9]

    cmp al, 32          ;check if is space
    je _getNbCurrentLineArgLoop

    inc r9
    jmp _hidenChar

_itChar:
    inc r8
    jmp _hidenChar


;rdi = currentLine
;rsi = nb of char was stored in currentLine
;r9  = index of currentLine
;r8  = nb of arg
_getNbCurrentLineArgLoop:
    cmp r9, rsi
    je _quit

    mov al, [rdi + r9]
    cmp al, 32
    jne _itChar

    inc r9
    jmp _getNbCurrentLineArgLoop

_getNbCurrentLineArg:
    push rbp
    mov rbp, rsp

    xor r8, r8
    xor r9, r9
    xor rax, rax
    call _getNbCurrentLineArgLoop

    mov rsp, rbp
    pop rbp
    ret

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