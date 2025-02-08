;ft__strdup.s
section .data

section .bss

section .text
global  ft_strdup

extern ft_strlen
extern ft_strcpy
extern malloc

ft_strdup:
	xor  rax, rax
	push rdi
	call ft_strlen
	inc  rax
	mov  rdi, rax
	call malloc wrt ..plt
	cmp  rax, 0
	je   end_fail
	pop  rsi
	mov  rdi, rax
	call ft_strcpy

	ret

end_fail:
	xor rax, rax

	ret