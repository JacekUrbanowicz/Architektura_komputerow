public suma_siedmiu_liczb

.code
suma_siedmiu_liczb PROC
	; prolog, utworzenie ramki stosu
	push rbp
	mov rbp, rsp
	push rbx

	; pierwsze 4 wartosci w rejestrach, uwzglêdniaj¹c schadow space przygotowanie wartoœci 5,6,7
	mov rbx, [rbp+48]
	mov r10, [rbp+56]
	mov r11, [rbp+64]

	; obliczanie sumy w rejestrze RAX
	mov rax, rcx
	add rax, rdx
	add rax, r8
	add rax, r9
	add rax, rbx
	add rax, r10
	add rax, r11


	; przywrócenie wartoœci rejestrów oraz powrót z funkcji
	pop rbx
	pop rbp
	ret
suma_siedmiu_liczb ENDP
END