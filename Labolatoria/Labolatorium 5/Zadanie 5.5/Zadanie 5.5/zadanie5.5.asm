.686 
.XMM
.model flat 
public _pm_jeden

.data
tablica dd +1.0 
		dd +1.0
		dd +1.0
		dd +1.0

.code
_pm_jeden PROC
	; prolog, utworzenie ramki stosu
	push ebp
	mov ebp, esp
	push ebx

	; pobranie pocz¹tkowych wartoœci
	mov ebx, [ebp+8]	; adres pierwszej tablicy

	; przes³anie zawartoœci tablicy pierwszej oraz tablicy drugiej do rejestrów
	movups xmm0, [ebx] 
	movups xmm1, dword PTR [tablica]

	; sumowanie elementów tablicy
	addsubps xmm0, xmm1

	; zapisanie wyniku w tablicy trzeciej 
	movups [ebx], xmm0

	pop ebx
	pop ebp
	ret
_pm_jeden ENDP
END