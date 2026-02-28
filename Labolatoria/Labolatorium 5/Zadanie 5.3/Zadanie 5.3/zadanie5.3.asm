.686 
.XMM
.model flat 
public _suma_tablic

.code
_suma_tablic PROC
	; prolog, utworzenie ramki stosu
	push ebp
	mov ebp, esp
	push ebx
	push edi
	push edx

	; pobranie pocz¹tkowych wartoœci
	mov ebx, [ebp+8]	; adres pierwszej tablicy
	mov edi, [ebp+12]	; adres drugiej tablicy
	mov edx, [ebp+16]	; adres trzeciej tablicy

	; przes³anie zawartoœci tablicy pierwszej oraz tablicy drugiej do rejestrów
	movups xmm0, [ebx] 
	movups xmm1, [edi]

	; sumowanie elementów tablicy
	paddsb xmm0, xmm1

	; zapisanie wyniku w tablicy trzeciej 
	movups [edx], xmm0

	pop edx
	pop edi
	pop ebx
	pop ebp
	ret
_suma_tablic ENDP
END