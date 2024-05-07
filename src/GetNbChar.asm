section .text

_charAtArg1:
    ;inc array[1]
    inc word [rdx + 2]
    jmp _getNbCurrentLineArgLoop
_charAtArg2:
    ;inc array[2]
    inc word [rdx + 4]
    jmp _getNbCurrentLineArgLoop

_charAtArg3:
    ;inc array[3]
    inc word [rdx + 6]
    jmp _getNbCurrentLineArgLoop

;on the current line, you have just one space between tow char so you can inc r8 to pass this space
_removeSpace:
    ;pass the space
    inc r8
    ;new arg
    jmp _itChar

_getNbCurrentLineArgLoop:
    cmp r8, rsi
    je _quit

    mov al, [rdi + r8]

    cmp al, 32          ;check if is space
    je _removeSpace

    inc r8

    ;looks at which argument is being looked at and stores in the array the number of characters for each argument
    cmp word [rdx], 1
    je _charAtArg1
    cmp word [rdx], 2
    je _charAtArg2
    cmp word [rdx], 3
    je _charAtArg3

    jmp _getNbCurrentLineArgLoop

_itChar:
    ;inc array[0]
    ;inc word [rbp + 32]
    inc word [rdx]
    jmp _getNbCurrentLineArgLoop

;you can't start current line with space so: 
_checkIfIsNotEmptyLine:
    ;check if currentligne have char.
    cmp r8, rsi
    je _quit
    jmp _itChar

;rdi = currentLine
;rsi = nb of char was stored in currentLine
;rdx = array position
;r8  = index of currentLine
;[rbp + 32 + 2*i] = array for storing nb of arg and the nb of char for ech arg
_getNbCurrentLineArg:
    push rbp
    mov rbp, rsp

    xor r8, r8
    xor rax, rax
    call _checkIfIsNotEmptyLine

    mov rsp, rbp
    pop rbp
    ret