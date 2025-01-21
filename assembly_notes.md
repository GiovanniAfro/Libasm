# Appunti Assembly x86_64 (Versione Estesa)

Questi appunti forniscono una panoramica sul funzionamento di base dell’assembly x86_64, con particolare attenzione ai **cicli di clock**, alla **pipeline** del processore, ai **registri**, alle **operazioni di memoria** e alle **istruzioni logiche**. L’obiettivo è spiegare in modo professionale ma semplice i concetti fondamentali

---

## 1. Cicli di Clock e Pipeline del Processore

### 1.1 Ciclo di Clock Base

- Il **ciclo di clock** (o **tick di clock**) è l’unità fondamentale di tempo del processore.  
- La frequenza è misurata in **Hertz (Hz)**, ad esempio un processore da **3.2 GHz** compie 3.2 miliardi di cicli al secondo.  
- All’interno di ogni ciclo di clock, la CPU può compiere una o più **micro-operazioni** (μops).  

> **Nota:** Le moderne CPU x86_64 sono in grado di eseguire più istruzioni (o micro-operazioni) in parallelo durante un singolo ciclo di clock, grazie a tecniche di **superscalarità** e **pipelining**.  

### 1.2 Pipeline di Esecuzione

La **pipeline** è un meccanismo che suddivide l’esecuzione di un’istruzione in più stadi, consentendo il parallelo tra istruzioni diverse. Le principali fasi sono:

1. **Fetch**: l’istruzione viene letta dalla memoria (tipicamente dalla cache).  
2. **Decode**: l’istruzione viene decodificata e tradotta in una o più micro-operazioni.  
3. **Execute**: la CPU elabora i dati e svolge l’operazione richiesta.  
4. **Memory**: avviene l’accesso alla memoria (lettura/scrittura) se necessario.  
5. **Write Back**: i risultati finali vengono scritti nei registri di destinazione.

Grazie alla pipeline, la CPU può cominciare il **Decode** di una seconda istruzione mentre la prima è ancora in **Execute**, e così via.

> **Approfondimento:**  
> - Le CPU moderne adottano spesso un’architettura **Out-of-Order Execution**, che permette di riordinare l’esecuzione delle istruzioni per minimizzare i tempi di attesa (ad esempio in presenza di dipendenze).  
> - Vi sono meccanismi avanzati come la **speculative execution** (esecuzione speculativa) e la **branch prediction** (predizione dei salti) per ridurre i ritardi dovuti alle ramificazioni nel codice.  
> - All’interno del core, le istruzioni in assembly vengono tradotte in **micro-operazioni (μops)** più semplici, che viaggiano lungo la pipeline.

### 1.3 Cicli di Clock e Latenza di Istruzione

Non tutte le istruzioni richiedono lo stesso numero di cicli di clock per completare le loro operazioni. Alcuni fattori che influenzano la **latenza** (ovvero il tempo di esecuzione) includono:

- **Tipologia dell’istruzione** (ad esempio, operazioni su interi, su floating-point, o operazioni complesse come divisioni).  
- **Dipendenze tra i registri** (se un’istruzione dipende dal risultato di un’altra, deve attendere il completamento di quest’ultima).  
- **Cache misses** (se i dati non si trovano nella cache, l’accesso alla memoria principale aumenta i cicli di attesa).  
- **Contesa delle risorse interne** (ad esempio, più istruzioni che competono per la stessa unità esecutiva).  

### 1.4 Esempio di Ottimizzazione

Una tipica ottimizzazione riguarda l’azzeramento di un registro:

```nasm
; Versione non ottimizzata (potrebbe richiedere più cicli)
mov rax, 0

; Versione ottimizzata (bitwise XOR, tipicamente 1 ciclo)
xor rax, rax

L’istruzione xor rax, rax è spesso più veloce (o, in molti casi, micro-ottimizzata) rispetto a mov rax, 0, in quanto non necessita di caricare il valore immediato 0 ed è trattata dalla pipeline come un’operazione logica elementare.

2. Registri e Memoria

2.1 Anatomia dei Registri

Nell’architettura x86_64, i registri possono essere utilizzati in diverse dimensioni. Ad esempio, il registro RDX (64 bit) può essere scomposto in:

RDX (64 bit)     |----------------------------------------------|
EDX (32 bit)     |                       -----------------------|
DX  (16 bit)     |                                   ---------|
DH  (8 bit)      |                                   --       |
DL  (8 bit)      |                                             --|

	•	RDX si riferisce all’intero registro a 64 bit.
	•	EDX ai 32 bit meno significativi di RDX.
	•	DX ai 16 bit meno significativi.
	•	DH e DL dividono i 16 bit in due blocchi da 8 bit ciascuno.

L’accesso a porzioni più piccole di un registro avviene spesso in operazioni di manipolazione di byte o di word.

2.2 Accesso ai Byte

Le istruzioni che coinvolgono i registri a 8 bit come DL sono utili quando si desidera leggere o scrivere un singolo byte:

mov dl, byte [rsi + rax]      ; Legge UN byte in DL
mov byte [rdi + rax], dl      ; Scrive UN byte da DL in memoria

Questo approccio è fondamentale per:
	•	La manipolazione di stringhe (ad esempio in funzioni di copia, confronto, concatenazione).
	•	Operazioni che coinvolgono caratteri ASCII/UTF-8.

3. Operazioni di Memoria

3.1 Sintassi delle Operazioni

In assembly x86_64 (sintassi AT&T o Intel, qui usiamo la forma Intel-like), l’istruzione mov segue tipicamente il formato:

mov destinazione, sorgente

Esempi:

mov dl, byte [rsi + rax]      ; LETTURA (memoria → registro)
mov byte [rdi + rax], dl      ; SCRITTURA (registro → memoria)

	Importante: In x86_64, non è consentito leggere direttamente da memoria e scrivere in memoria nella stessa istruzione (non esistono istruzioni mov [mem1], [mem2]).

3.2 Indirizzamento della Memoria

Il metodo comune di indirizzamento è del tipo:

[base + offset]
[rsi + rax]
[rsi + 8*rcx]        ; esempio di indicizzazione con scala
[rsi + rax*4 + 16]   ; combinazione di base, indice, offset

Dove:
	•	base è un registro (ad esempio rsi).
	•	offset è uno spostamento costante (immadiato).
	•	indice è un altro registro eventualmente moltiplicato per una scala (1, 2, 4, 8).

Queste modalità di indirizzamento consentono operazioni flessibili su strutture dati, array e campi di strutture.

4. Operazioni Logiche

4.1 XOR (Dettagli e Proprietà)

L’operazione bitwise XOR (^ in molti linguaggi ad alto livello) segue la tabella:

0 XOR 0 = 0
0 XOR 1 = 1
1 XOR 0 = 1
1 XOR 1 = 0

4.2 Utilizzi di XOR
	1.	Azzeramento dei registri

xor rax, rax      ; Azzeramento rapido di RAX
xor rdx, rdx      ; Azzeramento rapido di RDX

Viene sfruttata la proprietà x ^ x = 0.

	2.	Scambio di valori senza registro temporaneo

xor rax, rbx
xor rbx, rax
xor rax, rbx

Questo sequenza scambia il contenuto di rax e rbx senza utilizzare un registro di appoggio. Tuttavia, nelle CPU moderne, è spesso più veloce usare un registro temporaneo anziché la “tecnica XOR”.

5. Gestione delle Stringhe

5.1 Copia di Stringhe (Implementazione Base)

Esempio di funzione ft_strcpy che copia una stringa da rsi (sorgente) a rdi (destinazione) e ritorna l’indirizzo di destinazione in rax:

ft_strcpy:
    xor rax, rax            ; Inizializza contatore a 0 (RAX)
.loop:
    mov dl, byte [rsi + rax]   ; Legge il byte (sorgente)
    mov byte [rdi + rax], dl   ; Scrive il byte (destinazione)
    cmp dl, 0                  ; Se dl == 0 → fine stringa
    je .done
    inc rax
    jmp .loop

.done:
    mov rax, rdi               ; Ritorna l'indirizzo di destinazione
    ret

5.2 Ottimizzazione della Copia

La copia byte per byte è semplice ma potenzialmente lenta. Alcune ottimizzazioni possibili:
	•	Copia per word (2 byte) o doubleword (4 byte) o quadword (8 byte), sfruttando registri di dimensioni maggiori.
	•	Utilizzo di istruzioni SIMD (es. SSE, AVX) per copiare blocchi di dati più grandi in un singolo passaggio.
	•	Alcune CPU offrono istruzioni dedicate (es. movsb, movsd, movsq) per copiare dati in maniera sequenziale; tuttavia, le prestazioni rispetto a istruzioni SIMD possono variare in base alla microarchitettura.

6. Ulteriori Approfondimenti

6.1 Superscalarità e Out-of-Order Execution

Le moderne CPU x86_64 possono eseguire più micro-operazioni nello stesso ciclo di clock, grazie al design superscalare. In aggiunta, l’Out-of-Order Execution permette di riorganizzare l’ordine di esecuzione delle istruzioni (purché non vi siano dipendenze logiche che lo impediscano). Questo massimizza il throughput della pipeline, riducendo i cicli di attesa (stall).

6.2 Hazard e Pipeline Stall

Nonostante il pipelining, possono verificarsi hazard che impediscono di proseguire con le istruzioni successive:
	•	Data Hazard: l’istruzione successiva necessita di un dato che non è ancora disponibile (dipendenza in lettura).
	•	Control Hazard: in caso di salti e diramazioni (jmp, je, jne ecc.), la CPU può dover fare branch prediction. Se la predizione è errata, occorre svuotare parte della pipeline e ricaricare il flusso corretto di istruzioni (penalità in cicli di clock).

6.3 Micro-architettura Interna

Sotto al livello assembly, le istruzioni vengono scomposte in micro-ops ed eseguite da unità esecutive specializzate (ad esempio ALU, FPU, unità di load/store). La CPU gestisce un reorder buffer (ROB) per poter ritirare (commit) i risultati nell’ordine corretto, anche se l’esecuzione avviene in modo riorganizzato.

7. Riferimenti Utili
	•	Intel® 64 and IA-32 Architectures Software Developer’s Manual
	•	AMD64 Architecture Programmer’s Manual
	•	Documentazione ufficiale delle istruzioni assembly per approfondire opcode, cicli di clock e comportamento.

Conclusioni

In sintesi, la conoscenza delle fondamenta dell’assembly x86_64 e dei meccanismi di funzionamento della CPU (cicli di clock, pipeline, registri e memoria) è cruciale per l’ottimizzazione del codice a basso livello. Comprendere come la CPU decodifica ed esegue le istruzioni, e come gestisce le dipendenze e i salti, permette di scrivere routine molto performanti e di diagnosticare colli di bottiglia.
