.686 
.model flat 
public _liczba_przeciwna

.code 
_liczba_przeciwna PROC
	; prolog, utworzenie ramki stosu
	push ebp
	mov ebp, esp
	push ebx

	; zapisanie adresu otrzymanej zmiennej
	mov ebx, [ebp+8]

	; zamiana liczby na przeciwn¹
	mov eax, [ebx] ; odczytwanie wartoœci zmiennej
	neg eax ; negacja bitów liczby
	mov [ebx], eax ; odes³anie wyniku do zmiennej

	; przywrócenie wartoœci rejestrów oraz powrót z funkcji
	pop ebx
	pop ebp
	ret
_liczba_przeciwna ENDP
END