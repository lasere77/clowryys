bits 64
global _start

section .data
    hello db "start cloryys...", 10, 0
    helloLen equ $-hello

section .text
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, hello
    mov rdx, helloLen
    syscall

    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall