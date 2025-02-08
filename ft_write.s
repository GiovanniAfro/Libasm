section .text
global ft_write
extern __errno_location

ft_write:
    cmp rsi, 0
    je .error

    mov rax, 1
    syscall
    cmp rax, 0
    jl .error
    ret

.error:
    neg rax
    push rax
    
    call __errno_location wrt ..plt 
    pop rdx
    mov [rax], edx
    mov rax, -1
    ret
