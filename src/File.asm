section .text
_openFile:
    mov rax, 2           
    mov rdi, [rsp + 24]  ;move rdi to argv[1]
    mov rsi, 0           ;mode read-only
    syscall    

    ret

_readFile:
    mov rdi, rax         ;give the descriptor file
    mov rax, 0
    mov rsi, buffer      ;buffer to read into
    mov rdx, bufferSize  ;number of bytes to read
    syscall

    ret


_closeFile: 
    mov rax, 3
    mov rdi, 0
    syscall

    ret

_errorFilePath:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorFilePath
    mov rdx, errorFilePathLen
    syscall

    jmp _exitError