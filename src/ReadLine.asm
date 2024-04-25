section .text

_endOfLine:                 
    inc rdi                 ;hide \n from buffer
    ret

_storeCurrentLineLoop:
    mov byte al, [rdi + r8]

    cmp al, 0                   ;check if it end of line with \n
    je _quit

    cmp al, 10                  ;check if it end of line with \n
    je _endOfLine

    cmp r8, currentLineSize - 1 ;we do -1 to get a null byte
    jae _overflow               ;quit befor overflow!!! 

    cmp al, 59                  ;check if it end of line with comment
    je _hideUnnecessaryCharFromBuffer

    mov [rsi + r8], byte al

    inc r8
    jmp _storeCurrentLineLoop

;return buffer - currentLine
;rsi = buffer
;rdi = buffer to store CurrentLine
;r8  = index of currentLine and buffer
_storeCurrentLine: 
    push rbp
    mov rbp, rsp
    
    xor r8, r8
    xor rax, rax               ;I'm not sure it's necessary...
    call _storeCurrentLineLoop

    add rdi, r8                ;avoids incrementing the register in the loop
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