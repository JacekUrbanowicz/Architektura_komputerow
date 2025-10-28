; wczytywanie i wy�wietlanie tekstu wielkimi literami 
; (inne znaki si� nie zmieniaj�)

.686 
.model flat 
extern  _ExitProcess@4 : PROC 
extern  __write : PROC ; (dwa znaki podkre�lenia) 
extern  __read  : PROC ; (dwa znaki podkre�lenia)
extern  _MessageBoxA@16 : PROC
public  _main 

.data 
tekst_pocz    db 10, 'Prosz' 
			  db 0A9h ; literka � w kodzie szesnastkowym
			  db ' napisa'
			  db 86h ; literka � w kodzie szesnastkowym
			  db ' jaki'
			  db 98h ; literka � w kodzie szesnastkowym
			  db ' tekst i nacisn'
			  db 0A5h ; literka � w kodzie szesnastkowym
			  db 86h ; literka � w kodzie szesnastkowym
			  db ' Enter', 10
koniec_t      db ? 
magazyn       db 80 dup (?)
nowa_linia    db 10 
liczba_znakow dd ? 
tytul_MessageBox db 'Przekszta�cenie podnaych ma�ych liter na wielkie', 0

.code 
_main PROC 
; wy�wietlenie tekstu informacyjnego 

; liczba znak�w tekstu 
	mov     ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz) 
	push    ecx 
	push    OFFSET tekst_pocz  ; adres tekstu 
	push    1 ; nr urz�dzenia (tu: ekran - nr 1) 
	call    __write  ; wy�wietlenie tekstu pocz�tkowego 
	add     esp, 12 ; usuniecie parametr�w ze stosu 

; czytanie wiersza z klawiatury 
	push    80 ; maksymalna liczba znak�w 
	push    OFFSET magazyn 
	push    0  ; nr urz�dzenia (tu: klawiatura - nr 0) 
	call    __read ; czytanie znak�w z klawiatury 
	add     esp, 12 ; usuniecie parametr�w ze stosu 

; kody ASCII napisanego tekstu zosta�y wprowadzone 
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczb� 
; wprowadzonych znak�w 
	mov     liczba_znakow, eax 

; rejestr ECX pe�ni rol� licznika obieg�w p�tli 
	mov     ecx, eax 
	mov     ebx, 0

; indeks pocz�tkowy 
ptl: 
	mov     dl, magazyn[ebx] ; pobranie kolejnego znaku
	
	; modyfikacja dla polskich znak�w malych
	cmp dl, 0A5h ; znak � na �
	je znak_a
	cmp dl, 86h ; znak � na �
	je znak_c
	cmp dl, 0A9h ; znak � na �
	je znak_e
	cmp dl, 88h ; znak � na �
	je znak_l
	cmp dl, 0E4h ; znak � na �
	je znak_n
	cmp dl, 0A2h ; znak � na �
	je znak_o
	cmp dl, 98h ; znak � na �
	je znak_s
	cmp dl, 0ABh ; znak � na �
	je znak_zi
	cmp dl, 0BEh ; znak � na �
	je znak_zy

	; modyfikacja dla polskich znak�w wielkich
	cmp dl, 0A4h ; znak � na �
	je znak_a
	cmp dl, 8Fh ; znak � na �
	je znak_c
	cmp dl, 0A8h ; znak � na �
	je znak_e
	cmp dl, 9Dh ; znak � na �
	je znak_l
	cmp dl, 0E3h ; znak � na �
	je znak_n
	cmp dl, 0E0h ; znak � na �
	je znak_o
	cmp dl, 97h ; znak � na �
	je znak_s
	cmp dl, 8Dh ; znak � na �
	je znak_zi
	cmp dl, 0BDh ; znak � na �
	je znak_zy

	; znaki nie polskie
	cmp     dl, 'a' 
	jb      dalej   ; skok, gdy znak jest mniejszy niz a
	cmp     dl, 'z' 
	ja      dalej   ; skok, gdy znak jest wiekszy niz z 

	; zamiana na wielkie litery liter malych z odpowiedniego zakresu
	sub     dl, 20H ; zamiana na wielkie litery 
	jmp zapisz ; skok w celu ominiecia przekszta�cenia znakow polskich

	; modyfikacja dla polskich znak�w
	znak_a: 
		mov dl, 0A5h
		jmp zapisz
	znak_c:
		mov dl, 0C6h
		jmp zapisz
	znak_e:
		mov dl, 0CAh
		jmp zapisz
	znak_l:
		mov dl, 0A3h
		jmp zapisz
	znak_n:
		mov dl, 0D1h
		jmp zapisz
	znak_o:
		mov dl, 0D3h
		jmp zapisz
	znak_s:
		mov dl, 8Ch
		jmp zapisz
	znak_zi:
		mov dl, 8Fh
		jmp zapisz
	znak_zy:
		mov dl, 0AFh
		jmp zapisz

; odes�anie znaku do pami�ci 
	zapisz: 
		mov     magazyn[ebx], dl ; zapisanie przekszta�conego znaku
	dalej: 
		inc ebx  ; inkrementacja indeksu
	; przekroczenie zakresu loop 
	;loop    ptl     
	; sterowanie p�tl� 
	; zmiana loop ptl na
		dec ecx
		jnz ptl

; wy�wietlanie w MessageBoxie
	push 0
	push OFFSET tytul_MessageBox
	push OFFSET magazyn
	push 0
	call _MessageBoxA@16

	push    0 
	call    _ExitProcess@4      ; zako�czenie programu 
_main ENDP
END 