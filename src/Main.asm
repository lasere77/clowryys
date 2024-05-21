bits 64
global _start

%include "./src/File.asm"
%include "./src/ReadLine.asm"
%include "./src/GetNbChar.asm"
%include "./src/Assembler.asm"
%include "./src/RefAssembler.asm"

section .data
    ;message
    successfully db "successfully assembled.", 10, 0
    successfullyLen equ $-successfully

    errorFilePath db "error: please check if the file path is correct", 10, 0
    errorFilePathLen equ $-errorFilePath

    warnOverflow db "warn: an overflow has been avoided", 10, 0
    warnOverflowLen equ $-warnOverflow

    errorUnknownInstruction db "error: instruction not referenced, it doesn't exist", 10, 0
    errorUnknownInstructionLen equ $-errorUnknownInstruction

    errorNbTooLarge db "error: the nomber you give to the im instruction is too large, please check the nb is an integer in the interval [0;63]", 10, 0
    errorNbTooLargelen equ $-errorNbTooLarge

    errorInvalidReg db "error: invalid register", 10, 0
    errorInvalidRegLen equ $-errorInvalidReg

    errorCreatFile db "error: impossible to create a file here", 10, 0
    errorCreatFileLen equ $-errorCreatFile

    errorLineError db "error: can't print the line how you have an error...", 10
    errorLineErrorLen equ $-errorLineError

    errorPlsGetLine db "please check the line -> ", 0
    errorPlsGetLineLen equ $-errorPlsGetLine

    outputFileName db "binary.navo", 0

    ;const buffer size
    bufferSize equ 1024       ;1024 for the moment to be modified in the future
    currentLineSize equ 16
    currentLineBinSize equ 16 
    nbOfCharSize equ 2*4+8    ;2*4 for the array and add 8 to align the stack
    assemblyArgSize equ 8 
    assemblyLinSize equ 9     ;1 byte for the space and 8 bytes for the bin
    intToCharSize equ 8       

section .bss
    buffer resb bufferSize
    outputFileDescriptor resq 1

;
;add a label
;
section .text
_start:
    ;openFile with argv[1]
    call _openInuputFile

    ;check if the file is correctly opened
    cmp rax, 0
    jl _errorInputFilePath
    
    ;move file descriptor to r15
    mov r15, rax

    call _readInputFile
    call _closeInputFile

    ;creat and open output file
    call _openOutputFile
    cmp rax, 0
    jl _errorOutputFile

    ;move file descriptor to outputFileDescriptor
    mov [outputFileDescriptor], rax

    ;buffer for countain currenteline
    ;stores the line who need to transcode in to binary, 16 byte was allocated
    sub rsp, currentLineSize
    lea rax, [rsp]
    ;allocate memory to store nb of arg are in currentLine and nb of char for each arg
    sub rsp, nbOfCharSize

    mov r15, buffer
    jmp _mainLoop


;r15 = ptr for buffer
;r14 = line storyteller for input file
_mainLoop:
    mov r9, [r15]
    cmp r9, 0      ;check if it end of file with the null byte
    je _exit

    ;clean the tow buffer currentLine and nbOfCharSize
    xor r8, r8
    lea rdi, [rsp]
    mov rsi, currentLineSize + nbOfCharSize
    call _cleanBuffer

    ;store the current line without storing unnecessary characters
    mov rdi, r15
    lea rsi, [rsp + 16]
    call _storeCurrentLine
    ;move rax(buffer - curentLine) to r15
    mov r15, rax
    ;inc line storyteller
    inc r14
    ;if r8 = 0 nothing are store so you can passe to the next line
    cmp r8, 0
    je _mainLoop

    ;get nb of information (instruction/opéran/opérande)
    lea rdi, [rsp + 16]
    mov rsi, r8
    lea rdx, [rsp + 8]
    call _getNbCurrentLineArg

    ;transcode the instruction of currentLine
    movzx rdi, word [rsp + 8 + 2]          ;gives the number of characters in the current instruction
    call _assemblyInstruction
    ;check if the current line contains the correct instruction if not, exit the program with error code
    cmp rax, -1
    je _UnknownInstruction

    ;check if only the instruction assembly is required if this is true, write it to the binary file otherwise assemble the other arg in currentLine 
    cmp byte [rsp + 8], 1
    je _writeBinary
    cmp byte [rsp + 8], 2
    je _assemblyLineWithTowArg
    cmp byte [rsp + 8], 3
    je _assemblyLineWithThreeArg

    jmp _mainLoop

_assemblyLineWithTowArg:
    ;please do swith statment if you have more instruction here
    cmp r8, IDIm
    je _assemblyImArg

    ;exit with an error if the instruction was not referenced, the program should have aborted before this happened...
    jmp _UnknownInstruction


_assemblyLineWithThreeArg:
    cmp r8, IDMov
    je _assemblyMovArg

    ;exit with an error if the instruction was not referenced, the program should have aborted before this happened...
    jmp _UnknownInstruction

_writeBinary:
    sub rsp, currentLineBinSize

    lea rdi, [rsp]
    mov rsi, 16
    xor r8, r8
    call _cleanBuffer

    mov byte [rsp], 32              ;put space before the binary line
    mov [rsp + 1], rax              ;put a binary line, [rsp + 1] to avoid deleting the space

    lea rsi, [rsp]
    mov rax, 1
    mov rdi, [outputFileDescriptor]
    mov rdx, assemblyLinSize
    syscall

    add rsp, currentLineBinSize

    jmp _mainLoop



;set all bytes of the buffer to 0
;rdi = buffer to clean
;rsi = lenght of buffer (8*x !!!)
_cleanBuffer:
    cmp r8, rsi
    je _quit

    mov qword [rdi + r8], 0

    add r8, 8
    jmp _cleanBuffer

_printSrcLineError:
    push rbp
    mov rbp, rsp

    ;print epilogue
    mov rax, 1
    mov rdi, 1
    mov rsi, errorPlsGetLine
    mov rdx, errorPlsGetLineLen - 1
    syscall

    sub rsp, intToCharSize
    ;set the value of the buffe with null Bytes
    mov qword [rsp], 0

    ;convert int to str
    lea rdi, [rsp]
    mov rax, r14
    mov r9, 10
    mov r8, -1                  ;set r8 to -1 to use all the byte you can use
    call _srcLineErrorItoa

    ;move the last Byte to \n
    mov byte [rsp + intToCharSize - 1], 10

    ;calculates the correct length and position of the ptr and write on the console the line error
    neg r8          ;set r8 positif
    mov rdx, r8     ;move to rdx the nomber of char was store in the buffer
    neg r8          ;set r8 to negative
    add r8, 8       ;add 8 to r8 to find the good position for the buffer, this have for consequance to avoid to write the null bytes
    add rdi, r8     ;set the good position for the ptr
    mov rsi, rdi    ;mov rsi as a ptr for the buffer
    mov rdi, 1
    mov rax, 1
    syscall

    add rsp, intToCharSize  ;free the allocated memory

    mov rsp, rbp
    pop rbp
    ret

_srcLineErrorItoa:
    cmp rax, 0
    je _quit
    ;to avoid the overflow
    cmp r8, -intToCharSize
    jle _errorPrintSrcLineError         ;jlE e to avoid to write on the last Byte

    ;div by 10 to passe to the next digit
    xor rdx, rdx
    div r9
    ;convert the current digit
    add dl, 48
    ;move the character in the buffer (reverse writing)
    mov [rdi + 7 + r8], dl

    ;update the buffer ptr
    dec r8
    jmp _srcLineErrorItoa


_errorPrintSrcLineError:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorLineError
    mov rdx, errorLineErrorLen - 1
    syscall 

    ;buffer(8), stack frame(8) + return addr(16) = 32
    mov rdi, 32
    jmp _exitError

_quit:
    ret

_UnknownInstruction:
    mov rax, 1
    mov rdi, 1
    mov rsi, errorUnknownInstruction
    mov rdx, errorUnknownInstructionLen - 1
    syscall

    call _printSrcLineError

    xor rdi, rdi
    jmp _exitError


;attention !!! be sure to set the right value at rdi !!! 
;rdi = nb of space has been allocated for the function, and its contents
_exitError:
    ;remove local var, save of rip/rsp...
    add rsp, rdi
    ;remove local var of the main fonction
    add rsp, currentLineSize + nbOfCharSize

    call _closeOutputFile

    mov rax, 60
    mov rdi, 1
    syscall

_exit:
    add rsp, currentLineSize + nbOfCharSize

    call _closeOutputFile

    mov rax, 1
    mov rdi, 1
    mov rsi, successfully
    mov rdx, successfullyLen - 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall