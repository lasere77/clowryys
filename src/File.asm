section .text
_openInuputFile:
    mov rax, 2
    mov rdi, [rsp + 24]  ;move rdi to argv[1]
    mov rsi, 0           ;mode read-only
    syscall

    ret

_readInputFile:
    mov rdi, rax         ;give the descriptor file
    mov rax, 0
    mov rsi, buffer      ;buffer to read into
    mov rdx, bufferSize  ;number of bytes to read
    syscall

    ret


_closeInputFile: 
    mov rax, 3
    mov rdi, r15    ;give the descriptor file
    syscall

    ret

_errorInputFilePath:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorFilePath
    mov rdx, errorFilePathLen - 1
    syscall

    ;quit prog!!!
    mov rax, 60
    mov rdi, 1
    syscall

_openOutputFile:
    mov rax, 2
    mov rdi, outputFileName
    mov rsi, 64 + 1 + 512           ;64 -> O_CREAT + 1 -> O_WRONLY + 512 -> O_TRUNC
    mov rdx, 420                    ;mod -> rw-r--r--
    syscall

    ret


_closeOutputFile:
    mov rax, 3
    mov rdi, [outputFileDescriptor]  ;give the descriptor file
    syscall 
    
    ret

_errorOutputFile:
    mov rax, 1
    mov rax, 1
    mov rax, errorCreatFile
    mov rax, errorCreatFileLen
    syscall

    ;quit prog!!!
    mov rax, 60
    mov rdi, 1
    syscall