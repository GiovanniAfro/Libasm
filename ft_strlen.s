section .text 		  			; Questa riga di codice dice all'assemblatore che stiamo definendo codice eseguibile
global ft_strlen      			; Rende la funzione visibile ad altri file (come 'extern' in C)

ft_strlen:			  			; Definizione della funzione (come in ft_strlen() in C)
	cmp rdi, 0		  			; Controlla se il puntatore e' NULL, Confronta il primo argomento (in rdi) con NULL
	je .error         			; Se rdi == 0, salta alla gestione errore

	xor rax, rax      			; exlusive or, azzera il contatore (rax = 0), ottimizzato in termini di cicli di clock

.loop:                          ; etichetta per il ciclo (come while(1) in C)
	cmp byte [rdi + rax], 0    ; confronta il byte corrente con '\0', [rdi + rax] e' come str[i] in C

	je .done					; se Byte == 0; abbiamo trovato la fine della stringa

	inc rax						; incrementa il contatore (i++ in C)
	jmp .loop					; Torna all'inizio del ciclo 

.done:							; Etichetta per l'uscita normale
	ret							; Ritorna dal sottoprogramma con il valore in rax

.error:
	xor rax, rax
	ret