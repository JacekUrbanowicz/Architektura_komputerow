.686 
.model flat 
public _nowy_exp

.data
jedynka dd +1.0

.code
_nowy_exp PROC
	; prolog, utworzenie ramki stosu
	push ebp
	mov ebp, esp
	push ecx
	push eax

	; pobranie pocz¹tkowych wartoœci
	mov ecx, 19		  ; liczba wyrazów ci¹gu po przetworzeniu pierwszego wyrazu
	mov eax, 1		  ; liczba przetworzonych wyrazór po przetworzeniu pierwszego wyrazu (n)

	; wpisanie na stos koprocesora sumy przetworzonych wyrazów
	fld jedynka

	; wpisanie na stos koprocesora pierwszego wyrazu ci¹gu
	fld jedynka

	; wpisanie na stos koprocesora podstawy ci¹gu
	fld dword PTR [ebp+8]

	petla_ciagu:

		; skopiowanie poprzedniego wyrazu w celu stworzenia kolejnego
		fld st(1)

		; obliczenie licznika przetwarzanego wyrazu
		fmul st(0), st(1)

		; wpisanie numeru przetwarzanego wyrazu zawartego w eax (n)
		push eax
		fild dword PTR [esp]
		add esp, 4

		; obliczenie przetwarzanego wyrazu
		fdiv st(1), st(0)

		; usuniêcie poprzedniego wyrazu
		fstp st(0)

		; zamienienie poprzedniego wyrazu z aktualnie przetwarzanym
		fxch st(2)

		; usuniêcie poprzedniego wyrazu
		fstp st(0)

		; obliczanie sumy wyrazów przez dodanie przetworzonego wyrazu do sumy
		fxch
		fadd st(2), st(0)
		fxch

		; zwiêkszenie liczby przetworzonych wyrazów
		inc eax
		loop petla_ciagu

	; usuniêcie podstawy ci¹gu oraz poprzedniego wyrazu ze stosu koprocesora
	fstp st(0)
	fstp st(0)

	; przywrócenie wartoœci rejestrów oraz powrót z funkcji
	pop eax
	pop ecx
	pop ebp
	ret
_nowy_exp ENDP
END