section .text

_endOfLine:                 
    inc rdi                 ;hide \n from buffer
    ret


;this label is there to avoid storing unnecessary space
_getIfIsEssentialSpace:
    inc r9          ;pass to the next char after this condition

    cmp qword [rsp + 8], 1
    jne _storeCurrentLineLoop

    mov qword [rsp + 8], 0          ;set [rsp + 8] to 0 to tell do not store the next char if it space
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

    mov [rsi + r8], byte al

    inc r8
    inc r9
    mov qword [rsp + 8], 1      ;set [rsp + 8] to 1 to tell i can store space
    jmp _storeCurrentLineLoop

;return buffer - currentLine
;rdi = buffer to store CurrentLine
;rsi = buffer
;r8  = index of currentLine
;r9  = index of buffer
;VAR = if [rsp + 8] == 0 store space else do not store it
;to store a space we need VAR/[rsp + 8] == 0
_storeCurrentLine: 
    push rbp
    mov rbp, rsp
    
    sub rsp, 8                 ;allocate 8 bytes for stack alignment
    mov qword [rsp + 8], 0

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
    mov byte al, [rdi]

    cmp al, 10             ;check if it end of line with \n
    je _endOfLine

    inc rdi
    jmp _hideUnnecessaryCharFromBuffer