section .text
_initLabels:
    push rbp
    mov rbp, rsp

    ;set endHeapLabelTab to endHeapSrcFile
    mov rax, [endHeapSrcFile]
    mov [endHeapLabelTab], rax

    
    mov rax, [origineHeap]          ;mov the address where the input file was stored to rax
    xor r10, r10                    ;set r10 to 0

    call _loadLabels

    mov rsp, rbp
    pop rbp
    ret


_loadLabels:
    cmp byte [rax], 0
    je _quit

    ;clean the tow buffer currentLine and nbOfCharSize
    xor r8, r8
    lea rdi, [rbp + 16]
    mov rsi, currentLineSize + nbOfCharSize
    call _cleanBuffer

    ;store the current line without storing unnecessary characters
    mov rdi, rax
    lea rsi, [rbp + 32]
    call _storeCurrentLine
    ;if r8 = 0 nothing are store so you can passe to the next line
    cmp r8, 0
    je _loadLabels         ;pass to the next ligne
    inc r10                ;inc r10 to count the number of line

    lea rdi, [rbp + 32]
    xor r8, r8
    call _getIfItLabel
    cmp r8, 1              ;check if it label
    jne _loadLabels


    dec r10                 ;dec r10 you don't want to count the initialization of label
    ;store it
    call _storeLabel

    jmp _loadLabels


;return 1(in r8) if it a label
_getIfItLabel:
    cmp byte [rdi], 0
    je _quit

    cmp byte [rdi], 58
    je _itLabel

    inc rdi
    jmp _getIfItLabel

_itLabel:
    mov byte [rdi], 0 ;replace ":" by a null byte 
    mov r8, 1
    ret


;
;16 bytes for the name of the label, and 4 bytes to store the position of the label
;
_storeLabel:
    push rax
    ;allocate memory
    mov rdi, [endHeapLabelTab]
    add rdi, 20
    mov rax, 12
    syscall

    ;update addr of endHeapLabelTab
    mov [endHeapLabelTab], rax


    sub rax, 20                     ;set rax to the start of the addr of this case in the tab

    mov rdx, [rsi]                  ;move 8 chars of the string into rdx
    mov [rax], rdx                  ;move on this addr 8 chars of the name of the label
    add rsi, 8                      ;pass to the next char of the string
    add rax, 8                      ;pass to the next space where you can store the char
    mov rdx, [rsi]                  ;move 8 chars of the string into rdx
    mov [rax], rdx                  ;move on this addr 8 chars of the name of the label

    add rax, 8
    
    mov [rax],  r10d                ;move dword of r10(pos of label) on the addr of rax

    pop rax
    ret

_checkCorrespondingLabels:
    cmp rax, [endHeapLabelTab]
    je _errorLabelNotFound

    ;retrieve the length of the label name from the array
    push rax 
    mov rdi, rax
    xor rax, rax
    call _strLen
    mov r8, rax

    ;retrieve the length of the label name from the current line
    mov rdi, rsi
    xor rax, rax
    call _strLen
    mov r9, rax
    pop rax

    ;check if the tow strings have the same size
    cmp r8, r9
    jne _passLabel

    lea rdi, [rax]
    ;rsi has already the string
    mov rcx, r8         ;give to rcx the lenght of the string 
    rep cmpsb
    je _correspondingLabel
    sub rsi, r8        ;reset to start of string
    ;move on to the next label using the _passLabel label caution: do not move this label from underneath this one
_passLabel:
    add rax, 20
    jmp _checkCorrespondingLabels


_correspondingLabel:
    add rax, 16                 ;add 16 to the addr of rax to pass the string and acces to the line of the label
    mov eax, dword [rax]        ;give to rax(eax) the line of this label
    ret

_errorLabelNotFound:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorLabelNotFound
    mov rdx, errorLabelNotFoundLen - 1
    syscall

    call _printSrcLineError

    mov rdi, 32
    call _exitError

_errorLabelSpace:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorLabelSpace
    mov rdx, errorLabelSpaceLen - 1
    syscall

    call _printSrcLineError

    ;mov rdi, 16
    call _exitError