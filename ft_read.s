section .text
global ft_read
extern __errno_location    ; Dichiara la funzione esterna per ottenere l'indirizzo di errno

ft_read:
    ; La funzione read ha la seguente firma in C:
    ; ssize_t read(int fd, void *buf, size_t count);
    ; I parametri vengono passati così:
    ;   rdi = file descriptor (fd)
    ;   rsi = puntatore al buffer (buf)
    ;   rdx = numero di byte da leggere (count)

    cmp rsi, 0            ; Verifica che il puntatore al buffer non sia NULL
    je .error             ; Se rsi è NULL, salta alla gestione dell'errore

    mov rax, 0            ; Imposta rax al numero della syscall per read (0 per read in Linux)
    syscall               ; Esegue la syscall: verranno usati rdi, rsi e rdx come parametri

    cmp rax, 0            ; Dopo la syscall, rax contiene il numero di byte letti oppure un valore negativo in caso di errore
    jl .error             ; Se rax è negativo, salta alla gestione dell'errore

    ret                   ; Se tutto va bene, ritorna il numero di byte letti

.error:
    ; In caso di errore, il kernel restituisce un valore negativo in rax.
    ; Dobbiamo settare errno con il codice d'errore (in valore positivo) e restituire -1.
    neg rax               ; Rende il codice d'errore positivo
    push rax              ; Salva il codice d'errore sullo stack
    call __errno_location wrt ..plt ; Ottiene l'indirizzo della variabile errno
    pop rdx               ; Recupera il codice d'errore dallo stack
    mov [rax], edx        ; Imposta errno con il codice d'errore
    mov rax, -1           ; Imposta il valore di ritorno a -1 per indicare l'errore
    ret
