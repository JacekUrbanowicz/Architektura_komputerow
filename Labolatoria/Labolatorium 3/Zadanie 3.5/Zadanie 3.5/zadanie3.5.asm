.686 
.model flat 
extern __write : PROC 
extern __read : PROC
extern _ExitProcess@4 : PROC 
public _main 

.data 
obszar  db 12 dup (?) ; deklaracja tablicy do przechowywania wprowadzanych cyfr 
dziesiec  dd 10       ; mno¿nik
dekoder db '0123456789ABCDEF'

.code
wczytaj_do_EAX PROC
    ; zapamiêteanie na stosie u¿ytych rejestrów z wy³¹czeniem EAX (w nim znajduje siê wynik) oraz ESP
    push ebx
    push ecx
    push edx

    ; wywo³anie funckji __read w celu wczytania zanków podanych przez u¿ytkownika    
    push  dword PTR 12            ; max iloœæ znaków wczytywanej liczby  
    push  dword PTR OFFSET obszar ; adres obszaru pamiêci 
    push  dword PTR 0 ; numer urz¹dzenia (0 dla klawiatury) 
    call  __read      ; odczytywanie znaków z klawiatury 
                      ; (dwa znaki podkreœlenia przed read) 
    add  esp, 12      ; usuniêcie parametrów ze stosu

    ; bie¿¹ca wartoœæ przekszta³canej liczby przechowywana jest w rejestrze EAX
    mov   eax, 0            ; przyjmujemy 0 jako wartoœæ pocz¹tkow¹ 
    mov  ebx, OFFSET obszar ; adres obszaru ze znakami

     pobieraj_znaki: 
         mov  cl, [ebx] ; pobranie kolejnej cyfry w kodzie ASCII 
         inc  ebx   ; zwiêkszenie indeksu 
         cmp  cl,10 ; sprawdzenie czy naciœniêto Enter 
         je  byl_enter ; skok, gdy naciœniêto Enter 
         sub  cl, 30H  ; zamiana kodu ASCII na wartoœæ cyfry 
         movzx ecx, cl ; przechowanie wartoœci cyfry w rejestrze ECX 
         mul  dword PTR dziesiec ; mno¿enie wczeœniej obliczonej wartoœci razy 10          
         add  eax, ecx       ; dodanie ostatnio odczytanej cyfry do rejestru EAX 
         jmp  pobieraj_znaki ; skok na pocz¹tek pêtli

     byl_enter: 
         ; zdjêcie zapisanych rejestrów ze stosu
         pop edx
         pop ecx
         pop ebx
         ret
wczytaj_do_EAX ENDP

wyswietl_EAX_hex PROC 
; wyœwietlanie zawartoœci rejestru EAX w postaci liczby szesnastkowej 
	pusha  ; przechowanie rejestrów

; rezerwacja 12 bajtów na stosie (poprzez zmniejszenie rejestru ESP) przeznaczonych 
; na tymczasowe przechowanie cyfr szesnastkowych wyœwietlanej liczby
	sub  esp, 12 
	mov  edi, esp ; adres zarezerwowanego obszaru pamiêci

; przygotowanie konwersji            
	mov  ecx, 8 ; liczba obiegów pêtli konwersji 
	mov  esi, 1 ; indeks pocz¹tkowy u¿ywany przy zapisie cyfr

	; pêtla konwersji 
	ptl3hex:

		; przesuniêcie cykliczne (obrót) rejestru EAX o 4 bity w lewo 
		; w szczególnoœci, w pierwszym obiegu pêtli bity nr 31 - 28 
		; rejestru EAX zostan¹ przesuniête na pozycje 3 - 0 
		rol  eax, 4

		; wyodrêbnienie 4 najm³odszych bitów i odczytanie z tablicy 
		; 'dekoder' odpowiadaj¹cej im cyfry w zapisie szesnastkowym 
		mov  ebx, eax		  ; kopiowanie EAX do EBX 
		and  ebx, 0000000FH	  ; zerowanie bitów 31 - 4  rej.EBX 
		mov  dl, dekoder[ebx] ; pobranie cyfry z tablicy

		; przes³anie cyfry do obszaru roboczego 
		mov  [edi][esi], dl  
 
		inc  esi	  ; inkrementacja modyfikatora 
		loop  ptl3hex ; sterowanie pêtl¹

	; przygotowanie do dodawania spacji            
	mov  ecx, 8 ; liczba obiegów pêtli konwersji 
	mov  esi, 1 ; indeks pocz¹tkowy u¿ywany przy zapisie cyfr
	mov  ebx, 0 ; rejestr do pobierania znaków
	mov  edx, 0 ; rejestr do przesy³ania gwiazdek

	; pêtla dodaj¹ca spacje
	petla_spacje:
		mov bl, [edi][esi] ; pobranie znaku do rejestru BL
		sub bl, 30h ; zamiana kodu ASCII znaku na liczbê w rejestrze BL
		cmp bl, 0	; sprawdzenie czy liczba jest zerem
		jne koniec_zer ; wyjscie z pêtli podczas trafienia na pierwsz¹ liczbê nie bêd¹c¹ nieznacz¹cym zerem
		mov dl, 42			; wpisanie gwiazdki do rejestru DL
		mov [edi][esi], dl  ; przes³anie gwiazdki z rejestru DL w miejsce nieznacz¹cego zera 
		inc esi				; przesuniêcie na kolejny znak
		loop petla_spacje	; sterowanie pêtl¹

	; etykieta wyjœcia z pêtli
	koniec_zer:

	; wpisanie znaku nowego wiersza przed i po cyfrach 
	mov  byte PTR [edi][0], 10 
	mov  byte PTR [edi][9], 10 

	; wyœwietlenie przygotowanych cyfr
	push 10		 ; 8 cyfr + 2 znaki nowego wiersza
	push edi	 ; adres obszaru roboczego
	push 1		 ; nr urz¹dzenia (tu: ekran) 
	call __write ; wyœwietlenie
	
	; usuniêcie ze stosu 24 bajtów, w tym 12 bajtów zapisanych 
	; przez 3 rozkazy push przed rozkazem call 
	; i 12 bajtów zarezerwowanych na pocz¹tku podprogramu
	add esp, 24  

	popa ; odtworzenie rejestrów  
	ret ; powrót z podprogramu 
wyswietl_EAX_hex ENDP

_main PROC 
	; wczytywanie liczby do rejestry EAX w celu jej pomno¿enia
	call wczytaj_do_EAX

	; wyswietlenie liczby
	call wyswietl_EAX_hex

	; zakonczenie dzialania programu
	push 0 
	call _ExitProcess@4 
_main ENDP 
END