bits 64
global _start

section .data
    hello db "start cloryys...", 10, 0
    helloLen equ $-hello

    errorFilePath db "error: please check if the file path is correct", 10, 0
    errorFilePathLen equ $-errorFilePath

    bufferSize equ 1024      ;1024 for the moment to be modified in the future


section .bss
    buffer resb bufferSize
    filePath resb 1           ;pointer to the filepath

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
    call _closeFile   


    jmp _exit

_getArg:
    mov rax, [rsp + 24]
    ret

_openFile:
    push rbp
    mov rbp, rsp

    mov rax, 2           
    mov rdi, [filePath]  
    mov rsi, 0           ;mode read-only
    syscall    

    mov rsp, rbp
    pop rbp
    ret

_readFile:
    push rbp
    mov rbp, rsp

    mov rdi, rax         ;give the descriptor file
    mov rax, 0
    mov rsi, buffer      ;buffer to read into
    mov rdx, bufferSize  ;number of bytes to read
    syscall

    mov rsp, rbp
    pop rbp
    ret


_closeFile:
    push rbp
    mov rbp, rsp

    ;close File 
    mov rax, 3
    mov rdi, 0
    syscall

    mov rsp, rbp
    pop rbp
    ret

_errorFilePath:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorFilePath
    mov rdx, errorFilePathLen
    syscall

    jmp _exit


_exit:
    mov rax, 60
    mov rdi, 0
    syscall