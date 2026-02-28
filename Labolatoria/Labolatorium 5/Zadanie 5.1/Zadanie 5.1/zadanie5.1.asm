.686 
.model flat 
public _srednia_harm

.data
zero dd 0.0
jedynka dd +1.0

.code
_srednia_harm PROC
	; prolog, utworzenie ramki stosu
	push ebp
	mov ebp, esp
	push ebx
	push ecx

	; pobranie pocz¹tkowych wartoœci
	mov ebx, [ebp+8]  ; adres tablicy
	mov ecx, [ebp+12] ; liczba elemntów tablic

	; przygotowanie zera do obliczania mianownika
	fld zero

	petla_mianownik:
		; wpisanie pocz¹tkowych wartoœci na stos koprocesora do obliczenia mianownika
		fld dword PTR [ebx] 
		fld jedynka

		; obliczanie pojedynczego sk³adnika mianownika
		fdiv st(0), st(1)

		; wyczyszczenie pobranego elementu tablicy
		fstp st(1)
		
		; obliczanie sumy dwóch kolejnych sk³adników mianownika
		fadd st(0), st(1)

		; usuniêcie pobranego wczeœniej zera potrzebnego do obliczenia pierwszego sk³adnika, 
		; w nastêpnych iteracjach pêtli sk³adników 1/a1, 1/a1 + 1/a2 ...
		fstp st(1)

		; pobranie kolejnych elementów tablicy
		add ebx, 4
		loop petla_mianownik

	; przywrócenie licznika oraz wpisanie go na wierzcho³ek koprocesora
	fild dword PTR [ebp+12] 

	; obliczenie wyniku
	fdiv st(0), st(1)

	; usuniêcie mianownika
	fstp st(1)

	; przywrócenie wartoœci rejestrów oraz powrót z funkcji
	pop ecx
	pop ebx
	pop ebp
	ret
_srednia_harm ENDP
END