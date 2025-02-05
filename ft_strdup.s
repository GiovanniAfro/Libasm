section .text
global ft_strdup
extern malloc         ; Dichiarazione esterna per poter chiamare malloc
extern ft_strlen      ; Dichiarazione esterna per usare la funzione ft_strlen (già implementata)
extern ft_strcpy      ; Dichiarazione esterna per usare la funzione ft_strcpy (già implementata)

ft_strdup:
    cmp rdi, 0           ; Verifica se il puntatore sorgente (stringa da duplicare) è NULL
    je .error            ; Se sì, salta alla gestione dell'errore

    push rdi             ; Salva il puntatore sorgente sullo stack (ci servirà dopo)
    call ft_strlen       ; Chiama ft_strlen; l'argomento (la stringa) è in rdi; restituisce la lunghezza in rax
    pop rsi              ; Recupera il puntatore sorgente dallo stack e lo pone in rsi (source per la copia)
    add rax, 1           ; Aggiunge 1 alla lunghezza per includere il terminatore nullo ('\0')
    mov rdi, rax         ; Prepara il parametro per malloc: la dimensione da allocare
    call malloc          ; Alloca memoria; il puntatore all'area allocata viene restituito in rax
    test rax, rax        ; Verifica se malloc ha restituito NULL (0)
    je .error_malloc     ; Se malloc fallisce, salta alla gestione dell'errore per malloc

    ; Ora, in rax c'è il puntatore all'area di memoria allocata e in rsi c'è il puntatore alla stringa originale.
    mov rdi, rax         ; Prepara il primo parametro per ft_strcpy: destinazione (l'area allocata)
    ; Il secondo parametro (la sorgente) è già in rsi.
    call ft_strcpy       ; Copia la stringa dalla sorgente alla destinazione
    ret                  ; Ritorna il puntatore alla nuova stringa (valore restituito da ft_strcpy)

.error:
    xor rax, rax         ; In caso di errore (ad es. puntatore sorgente NULL), restituisce NULL (0)
    ret

.error_malloc:
    xor rax, rax         ; Se malloc fallisce, restituisce NULL (0)
    ret
