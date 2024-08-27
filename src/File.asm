section .text
_openInuputFile:
    mov rax, 2
    mov rdi, [rsp + 24]  ;move rdi to argv[1]
    mov rsi, 0           ;mode read-only
    syscall

    ret
_readInputFile:

    call _getSizeOfInputFile
    mov rdi, rax         ;move to rdi the length to the buffer/allocated memory
    push rdi             ;save on the stack the length to the buffer/allocated memory
    call _allocateMemoryForFile

    mov rax, 0                     ;sys_read
    mov rdi, [InputFileDescriptor] ;give the descriptor file
    mov rsi, [origineHeap]         ;give the addr to store the file, original brk
    pop rdx                        ;give the length to the buffer/allocated memory from the stack
    syscall

    ret

;return rax == nb of byte necessary to store the integrality of the file + an offset
_getSizeOfInputFile:
    push rbp
    mov rbp, rsp

    sub rsp, 144        ;allocate 144 Byte on the stack to store the result of sys_fstat

    mov rax, 5                          ;sys_fstat
    mov rdi, [InputFileDescriptor]      ;passe to rdi the file descriptor
    lea rsi, [rsp]                      ;lea rsi the place to store the struct
    syscall

    ;check if sys_fstat has an error
    cmp rax, 0
    jl _errorSysFstat

    mov rax, [rsp + 48]         ;mov rax has the number of bytes required to store this file(48 is the offset to find the length of the file(st_size))
    add rax, 8                  ;to include the null byte and add a small margin

    add rsp, 144                ;remove the allocated space that was been use to store the sys_fstat

    mov rsp, rbp
    pop rbp
    ret

_errorSysFstat:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorFstat
    mov rdx, errorFstatLen - 1
    syscall

    mov rdi, 144+16         ;144 the allocated memory to store the result of sys_fstat and 16 for the fonction
    jmp _exitError

;return rax == the new addr to brk(the end of the new buffer)
;rdi == the length to allocate
_allocateMemoryForFile:
    mov rax, [origineHeap] ;move to rax the original addr to brk

    add rdi, rax           ;to calculate the new addr to brk
    mov rax, 12
    syscall                ;allocate memory

    mov [endHeapSrcFile], rax

    ret


_closeInputFile: 
    mov rax, 3
    mov rdi, [InputFileDescriptor] ;give the descriptor file
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