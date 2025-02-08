section .text
global ft_strdup
extern ft_strlen
extern malloc
extern ft_strcpy

; char *ft_strdup(const char *src);
ft_strdup:
    ; Controlla se src == NULL
    cmp rdi, 0
    je .error

    ; Calcola la lunghezza con ft_strlen
    push rdi        ; Salviamo rdi (src) perché ft_strlen userà rdi come parametro
    call ft_strlen
    pop rsi         ; rsi = src
    ; rax adesso contiene la lunghezza

    add rax, 1      ; +1 per '\0'

    ; Chiamata a malloc (size_t = rax)
    mov rdi, rax
    call malloc wrt ..plt
    test rax, rax
    je .error       ; se malloc fallisce, 0

    ; ft_strcpy(dest, src)
    mov rdi, rax    ; destinazione = ptr allocato
    ; sorgente = rsi
    call ft_strcpy  ; rax = dest
    ret

.error:
    xor rax, rax
    ret
