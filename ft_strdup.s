section .text
global ft_strdup
extern ft_strlen
extern malloc
extern ft_strcpy

ft_strdup:
    cmp rdi, 0
    je .error

    ; Salva rdi (src) sullo stack per ft_strlen
    push rdi
    call ft_strlen
    ; Ritorna in rax la lunghezza
    pop rsi             ; rsi = src
    add rax, 1          ; +1 per '\0'

    mov rdi, rax        ; size per malloc
    call malloc wrt ..plt
    test rax, rax
    je .error

    mov rdi, rax        ; destinazione = area allocata
    ; rsi = sorgente (la stringa, rimasta invariata)
    call ft_strcpy      ; copia
    ret

.error:
    xor rax, rax
    mov rdi, 0
    ret

