section .text

_endOfLine:                 
    inc r9                 ;hide \n from buffer
    ret


;this label is there to avoid storing unnecessary space
_getIfIsEssentialSpace:
    inc r9          ;pass to the next char after this condition

    cmp qword [rbp - 8], 1
    jne _storeCurrentLineLoop

    mov qword [rbp - 8], 0          ;set [rbp - 8] to 0(false) to tell do not store the next char if it space
    mov [rsi + r8], byte al         ;write the space on currentLine
    inc r8

    jmp _storeCurrentLineLoop

_storeCurrentLineLoop:
    mov byte al, [rdi + r9]

    cmp al, 0                   ;check if it end of line with the null byte
    je _quit

    cmp al, 10                  ;check if it end of line with \n
    je _endOfLine

    cmp r8, currentLineSize - 1 ;we do -1 to get a null byte
    jae _overflow               ;quit befor overflow!!! 

    cmp al, 59                  ;check if it end of line with comment
    je _hideUnnecessaryCharFromBuffer
    
    cmp al, 32                  ;check if char is space
    je _getIfIsEssentialSpace

    cmp al, 44                  ;check if char is comma
    je _replaceComma

    mov [rsi + r8], byte al

    inc r8
    inc r9
    mov qword [rbp - 8], 1      ;set [rbp - 8] to (true)1 to tell i can store space
    jmp _storeCurrentLineLoop

;return buffer - currentLine
;rdi = buffer 
;rsi = buffer to store CurrentLine
;r8  = index of currentLine
;r9  = index of buffer
;VAR = if [rbp - 8] == (true)1 store space else do not store it
;to store a space we need VAR/[rbp - 8] == (true)1
_storeCurrentLine: 
    push rbp
    mov rbp, rsp
    
    sub rsp, 8                 ;allocate 8 bytes for check is space is needed in the buffer, and 8 for stack alignment
    mov qword [rbp - 8], 0

    xor r8, r8
    xor r9, r9
    xor rax, rax               ;I'm not sure it's necessary...
    call _storeCurrentLineLoop


    add rsp, 8                 ;free allocated memory

    add rdi, r9                ;avoids incrementing the register in the loop
    mov rax, rdi

    mov rsp, rbp
    pop rbp
    ret


_overflow:
    push rsi 
    push rdi

    mov rax, 1
    mov rdi, 1
    mov rsi, warnOverflow
    mov rdx, warnOverflowLen
    syscall

    pop rdi
    pop rsi

    call _hideUnnecessaryCharFromBuffer
    ret

_hideUnnecessaryCharFromBuffer:
    mov byte al, [rdi + r9]

    cmp al, 10             ;check if it end of line with \n
    je _endOfLine

    cmp al, 0              ;check if it end of line with the null byte
    je _endOfLine

    inc r9
    jmp _hideUnnecessaryCharFromBuffer

_replaceComma:
    inc r9

    cmp qword [rbp - 8], 1
    jne _storeCurrentLineLoop

    mov qword [rbp - 8], 0      ;set [rbp - 8] to (false)0 to tell hi can't store space
    mov byte [rsi + r8], 32     ;replace comma with space if is needed
    inc r8
    jmp _storeCurrentLineLoop