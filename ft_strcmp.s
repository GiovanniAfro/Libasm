section .text
global  ft_strcmp

ft_strcmp:
    cmp rdi, 0
    je .error
    cmp rsi, 0
    je .error

    xor rax, rax

.loop:
    mov dl, byte [rdi + rax]
    mov cl, byte [rsi + rax]
    cmp dl, cl
    jne .difference
    cmp dl, 0
    je .done 
    inc rax
    jmp .loop

.difference:
    sub dl, cl
    movsx rax, dl
    ret

.done:
    xor rax, rax
    ret

.error:
    mov rax, -1
    ret

