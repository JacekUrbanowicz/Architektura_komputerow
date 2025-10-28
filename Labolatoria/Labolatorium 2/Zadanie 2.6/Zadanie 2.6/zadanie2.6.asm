; wczytywanie i wyúwietlanie tekstu wielkimi literami 
; (inne znaki siÍ nie zmieniajπ)

.686 
.model flat 
extern  _ExitProcess@4 : PROC 
extern  __write : PROC ; (dwa znaki podkreúlenia) 
extern  __read  : PROC ; (dwa znaki podkreúlenia)
extern  _MessageBoxA@16 : PROC
public  _main 

.data 
tekst_pocz    db 10, 'Prosz' 
			  db 0A9h ; literka Í w kodzie szesnastkowym
			  db ' napisa'
			  db 86h ; literka Ê w kodzie szesnastkowym
			  db ' jaki'
			  db 98h ; literka ú w kodzie szesnastkowym
			  db ' tekst i nacisn'
			  db 0A5h ; literka π w kodzie szesnastkowym
			  db 86h ; literka Ê w kodzie szesnastkowym
			  db ' Enter', 10
koniec_t      db ? 
magazyn       db 80 dup (?)
nowa_linia    db 10 
liczba_znakow dd ? 
tytul_MessageBox db 'Przekszta≥cenie podnaych ma≥ych liter na wielkie', 0

.code 
_main PROC 
; wyúwietlenie tekstu informacyjnego 

; liczba znakÛw tekstu 
	mov     ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz) 
	push    ecx 
	push    OFFSET tekst_pocz  ; adres tekstu 
	push    1 ; nr urzπdzenia (tu: ekran - nr 1) 
	call    __write  ; wyúwietlenie tekstu poczπtkowego 
	add     esp, 12 ; usuniecie parametrÛw ze stosu 

; czytanie wiersza z klawiatury 
	push    80 ; maksymalna liczba znakÛw 
	push    OFFSET magazyn 
	push    0  ; nr urzπdzenia (tu: klawiatura - nr 0) 
	call    __read ; czytanie znakÛw z klawiatury 
	add     esp, 12 ; usuniecie parametrÛw ze stosu 

; kody ASCII napisanego tekstu zosta≥y wprowadzone 
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczbÍ 
; wprowadzonych znakÛw 
	mov     liczba_znakow, eax 

; rejestr ECX pe≥ni rolÍ licznika obiegÛw pÍtli 
	mov     ecx, eax 
	mov     ebx, 0

; indeks poczπtkowy 
ptl: 
	mov     dl, magazyn[ebx] ; pobranie kolejnego znaku
	
	; modyfikacja dla polskich znakÛw malych
	cmp dl, 0A5h ; znak π na •
	je znak_a
	cmp dl, 86h ; znak Ê na ∆
	je znak_c
	cmp dl, 0A9h ; znak Í na  
	je znak_e
	cmp dl, 88h ; znak ≥ na £
	je znak_l
	cmp dl, 0E4h ; znak Ò na —
	je znak_n
	cmp dl, 0A2h ; znak Û na ”
	je znak_o
	cmp dl, 98h ; znak ú na å
	je znak_s
	cmp dl, 0ABh ; znak ü na è
	je znak_zi
	cmp dl, 0BEh ; znak ø na Ø
	je znak_zy

	; modyfikacja dla polskich znakÛw wielkich
	cmp dl, 0A4h ; znak • na •
	je znak_a
	cmp dl, 8Fh ; znak ∆ na ∆
	je znak_c
	cmp dl, 0A8h ; znak   na  
	je znak_e
	cmp dl, 9Dh ; znak £ na £
	je znak_l
	cmp dl, 0E3h ; znak — na —
	je znak_n
	cmp dl, 0E0h ; znak ” na ”
	je znak_o
	cmp dl, 97h ; znak å na å
	je znak_s
	cmp dl, 8Dh ; znak è na è
	je znak_zi
	cmp dl, 0BDh ; znak Ø na Ø
	je znak_zy

	; znaki nie polskie
	cmp     dl, 'a' 
	jb      dalej   ; skok, gdy znak jest mniejszy niz a
	cmp     dl, 'z' 
	ja      dalej   ; skok, gdy znak jest wiekszy niz z 

	; zamiana na wielkie litery liter malych z odpowiedniego zakresu
	sub     dl, 20H ; zamiana na wielkie litery 
	jmp zapisz ; skok w celu ominiecia przekszta≥cenia znakow polskich

	; modyfikacja dla polskich znakÛw
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

; odes≥anie znaku do pamiÍci 
	zapisz: 
		mov     magazyn[ebx], dl ; zapisanie przekszta≥conego znaku
	dalej: 
		inc ebx  ; inkrementacja indeksu
	; przekroczenie zakresu loop 
	;loop    ptl     
	; sterowanie pÍtlπ 
	; zmiana loop ptl na
		dec ecx
		jnz ptl

; wyúwietlanie w MessageBoxie
	push 0
	push OFFSET tytul_MessageBox
	push OFFSET magazyn
	push 0
	call _MessageBoxA@16

	push    0 
	call    _ExitProcess@4      ; zakoÒczenie programu 
_main ENDP
END 