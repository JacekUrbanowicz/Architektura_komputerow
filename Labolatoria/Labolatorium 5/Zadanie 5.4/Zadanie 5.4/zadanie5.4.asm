.686 
.XMM
.model flat 
public _int2float

.code
_int2float PROC
	; prolog, utworzenie ramki stosu
	push ebp
	mov ebp, esp
	push ebx
	push edi

	; pobranie pocz¹tkowych wartoœci
	mov ebx, [ebp+8]	; adres pierwszej tablicy
	mov edi, [ebp+12]	; adres drugiej tablicy

	; konwersja liczb ca³kowitych na zmiennoprzecinkowe
	cvtpi2ps xmm0, qword PTR [ebx]

	; zapisanie wyniku w tablicy trzeciej 
	movups [edi], xmm0

	pop edi
	pop ebx
	pop ebp
	ret
_int2float ENDP
END