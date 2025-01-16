# Appunti Assembly x86_64

## 1. Introduzione ai Cicli di Clock e all'Ottimizzazione

### Ciclo di Clock
- Funziona come il "battito cardiaco" del processore
- Ogni istruzione assembly richiede un certo numero di cicli di clock per essere eseguita
- L'ottimizzazione mira a ridurre il numero di cicli necessari per un'esecuzione più veloce

### Efficienza
- La scelta delle istruzioni influenza:
  - Numero di cicli di clock consumati
  - Spazio in memoria del codice
- Esempio: `xor rax, rax` vs `mov rax, 0`
  - `xor` è più rapido e occupa meno byte

## 2. Registri e Dati in x86_64

### 2.1 Registri General Purpose
Nell'architettura x86_64 ci sono 16 registri "general purpose":

- **RAX**: Principalmente per risultati delle funzioni
- **RBX, RCX, RDX, RSI, RDI, R8, R9**, ecc.

Analogia dei registri:
- Come cassetti di una scrivania:
  - Limitati (solo 16)
  - Accesso velocissimo
  - Capacità limitata (64 bit ≈ 20 cifre decimali)

RAM:
- Come un magazzino:
  - Molto più grande
  - Accesso più lento

### 2.2 Passaggio degli Argomenti (Calling Convention)
System V AMD64 (Linux/Unix su x86_64):

1. RDI - Primo argomento
2. RSI - Secondo argomento
3. RDX - Terzo argomento
4. RCX - Quarto argomento
5. R8 - Quinto argomento
6. R9 - Sesto argomento

Argomenti aggiuntivi → Stack

## 3. XOR (Exclusive OR)

### Definizione
- "XOR" = eXclusive OR
- Risultato 1 solo se i bit sono diversi (0/1 o 1/0)

### Azzeramento Registri
`xor rax, rax` vs `mov rax, 0`:
- Meno cicli di clock (1 vs 2-3)
- Meno byte (2-3 vs 5-7)
- No caricamento valori dalla memoria

## 4. Etichette in Assembly

### Concetto
- Identificatori che marcano posizioni nel codice
- Come "segnalibri" o "cartelli stradali"

### Esempio
```nasm
.loop:
    ; codice del ciclo
    jmp .loop
.done:
    ; fine funzione
```

## 5. Istruzioni di Salto

### Tipi di Salto
- `je .done`: Jump if Equal
- `jmp .loop`: Salto incondizionato
- Altri: `jne`, `jg`, `jl`

## 6. Esempio di Funzione

```nasm
section .text
global my_function

my_function:
    ; RDI, RSI, RDX contengono i parametri
    xor rax, rax   ; azzera contatore
    
.loop:
    cmp byte [rdi + rax], 0
    je .done
    inc rax
    jmp .loop

.done:
    ret
```

### Struttura
- `global my_function`: Visibilità esterna
- `my_function:`: Punto di entrata
- Uso di registri e istruzioni base
- Gestione del flusso con etichette

## Conclusione

Concetti fondamentali:
1. Cicli di clock e ottimizzazione
2. Tecniche di azzeramento registri
3. Registri x86_64 e calling convention
4. Etichette e controllo di flusso
5. Struttura base delle funzioni assembly