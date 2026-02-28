.686 
.model flat 
public _odejmij_jeden

.code
_odejmij_jeden PROC
	; prolog, utworzenie ramki stosu
	push ebp
	mov ebp, esp
	push ebx
	push edx

	; zapisanie adresu otrzymanej zmiennej
	mov edx, [ebp+8]
	mov ebx, [edx]
	mov eax, [ebx]

	; odjêcie liczby 1
	dec eax

	; odes³anie wartoœci pod odpowiedni adres
	mov [ebx], eax
	mov [edx], ebx

	; przywrócenie wartoœci rejestrów oraz powrót z funkcji
	pop edx
	pop ebx
	pop ebp
	ret
_odejmij_jeden ENDP
END