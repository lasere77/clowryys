bits 64
global _start

%include "./src/File.asm"

section .data
    hello db "start cloryys...", 10, 0
    helloLen equ $-hello

    errorFilePath db "error: please check if the file path is correct", 10, 0
    errorFilePathLen equ $-errorFilePath

    bufferSize equ 1024      ;1024 for the moment to be modified in the future


section .bss
    buffer resb bufferSize
    filePath resq 1           ;pointer to the filepath, 8 byte was allocated
    currentLine resb 6        ;memorizes the instruction just read

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, hello
    mov rdx, helloLen
    syscall

    call _getArg
    mov [filePath], rax     ;store argv[1] in to filePath
    call _openFile

    ;check if the file is correctly opened
    cmp rax, 0
    jl _errorFilePath
    call _readFile
    call _getLine

    call _closeFile   


    jmp _exit

_getLineStoreChar:
    mov byte [rsi], al
    
    inc rsi
    inc rdi
    jmp _getLineLoop

_getLineLoop:
    mov al, byte [rdi]
    
    cmp al, 10      ;"\n"
    je _quit
    
    cmp al, 0x20    ;" "
    jne _getLineStoreChar
    
    inc rdi

    jmp _getLineLoop

_getLine:
    push rbp
    mov rbp, rsp

    mov rdi, buffer
    mov rsi, currentLine
    call _getLineLoop

    mov rsp, rbp
    pop rbp
    ret

_getArg:
    mov rax, [rsp + 24]
    ret

_quit:
    ret


_exit:
    mov rax, 60
    mov rdi, 0
    syscall