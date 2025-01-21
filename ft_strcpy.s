section .text
global ft_strcpy

ft_strcpy:
    cmp rdi, 0
    je .error 
    cmp rsi, 0
    je .error

    xor rax, rax

.loop:
    mov dl, byte [rsi + rax]
    mov byte [rdi + rax], dl
    cmp dl, 0
    je .done
    inc rax
    jmp .loop

.done:
    mov rax, rdi
    ret

.error:
    xor rax, rax
    ret