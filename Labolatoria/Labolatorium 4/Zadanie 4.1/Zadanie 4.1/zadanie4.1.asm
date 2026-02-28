.686 
.model flat 
public _szukaj_max 
 
.code 
_szukaj_max PROC 
	; prolog przygotowanie ramki stosu

	push  ebp  ; zapisanie zawartoœci EBP na stosie 
	mov  ebp, esp ; kopiowanie zawartoœci ESP do EBP 
 
	mov  eax, [ebp+8] ; liczba x 
	cmp  eax, [ebp+12] ; porownanie liczb x i y 
	jge  x_wieksza  ; skok, gdy x >= y 
 
	; przypadek x < y 
	mov  eax, [ebp+12] ; liczba y 
	cmp  eax, [ebp+16] ; porownanie liczb y i z 
	jge  y_wieksza  ; skok, gdy y >= z 

	; przypadek y < z oraz x < z
	mov eax, [ebp + 16] ; liczba z wpisana do eax
	cmp eax, [ebp + 20] ; porównianie liczby j i z
	jge zakoncz ; skok, gdy z >= j
 
	; przypadek z < j 
	; zatem z jest liczb¹ najwieksz¹ 
	wpisz_j: 
		mov eax, [ebp+20] ; liczba j zapisana do eax
 
	zakoncz: 
		pop  ebp 
		ret 
 
	x_wieksza: 
		cmp  eax, [ebp+16] ; porownanie x i z 
		jge  x_wieksza_drugi_raz  ; skok, gdy x >= z 
		mov eax, [ebp+16] ; wpisanie z do eax
		jmp  z_wieksza
 
	y_wieksza: 
		mov  eax, [ebp+12] ; liczba y wpisana do eax
		cmp eax, [ebp+16] ; porówanie y i z
		jge y_wieksza_drugi_raz ; skok gdy y >= z
		mov eax, [ebp+16] ; wpisanie z do eax
		jmp  z_wieksza 

	x_wieksza_drugi_raz:
		cmp eax, [ebp+20] ; porownanie x i j 
		jge  zakoncz  ; skok, gdy x >= j, x z eax najwiêksza liczba
		jmp  wpisz_j ; skok, gdy j > x, j najwiêksza 

	y_wieksza_drugi_raz:
		cmp eax, [ebp+20] ; porownanie y i j 
		jge  zakoncz  ; skok, gdy y >= j, y z eax najwiêksza liczba
		jmp  wpisz_j ; skok, gdy j > y, j najwiêksza

	z_wieksza:
		cmp eax, [ebp+20] ; porownanie z i j 
		jge zakoncz ; skok, gdy z >= j, z z eax najwiêksza liczba
		jmp wpisz_j ; skok, gdy j > z, j najwiêksza
 
_szukaj_max ENDP 
END