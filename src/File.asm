section .text
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