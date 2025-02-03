section .text
global ft_write
extern __errno_location  ; Dichiarazione della funzione esterna __errno_location (per Linux)

ft_write:
    cmp rsi, 0          ; Controlla se il puntatore al buffer è NULL
    je .error           ; Se è NULL, salta alla gestione errore

    mov rax, 1          ; Syscall per write (Linux)
    syscall             ; Esegui la syscall
    cmp rax, 0          ; Controlla se il valore di ritorno è negativo (errore)
    jl .error           ; Se è negativo, salta alla gestione errore
    ret                 ; Altrimenti, ritorna il numero di byte scritti

.error:
    neg rax             ; Converti il valore negativo in positivo (per ottenere il codice di errore)
    push rax            ; Salva il codice di errore nello stack
    call __errno_location ; Ottieni l'indirizzo di errno
    pop rdx             ; Recupera il codice di errore dallo stack
    mov [rax], edx      ; Imposta errno con il codice di errore
    mov rax, -1         ; Restituisci -1 per indicare un errore
    ret