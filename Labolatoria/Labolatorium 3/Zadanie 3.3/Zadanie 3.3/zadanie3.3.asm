.686 
.model flat 
extern __write : PROC 
extern __read : PROC
extern _ExitProcess@4 : PROC 
public _main 

.data 
znaki   db 12 dup (?)
obszar  db 12 dup (?) ; deklaracja tablicy do przechowywania wprowadzanych cyfr 
dziesiec  dd 10       ; mno¿nik

.code 
wyswietl_EAX PROC 
   pusha 

   mov  esi, 10  ; indeks w tablicy 'znaki' 
   mov  ebx, 10  ; dzielnik równy 10

   konwersja: 
		mov  edx, 0	 ; zerowanie starszej czêœci dzielnej 
		div  ebx	 ; dzielenie przez 10, reszta w EDX, 
					 ; iloraz w EAX 
		add  dl, 30H ; zamiana reszty z dzielenia na kod 
					 ; ASCII 
		mov  znaki [esi], dl ; zapisanie cyfry w kodzie ASCII 
		dec  esi   ; zmniejszenie indeksu 
		cmp  eax, 0  ; sprawdzenie czy iloraz = 0 
		jne  konwersja  ; skok, gdy iloraz niezerowy

	; wype³nienie pozosta³ych bajtów spacjami i wpisanie 
	; znaków nowego wiersza 
	wypeln: 
		or  esi, esi 
		jz  wyswietl  ; skok, gdy ESI = 0 
		mov  byte PTR znaki [esi], 20H ; kod spacji 
		dec  esi   ; zmniejszenie indeksu 
		jmp  wypeln 
  
	wyswietl: 
		mov  byte PTR znaki [0], 0AH ; kod nowego wiersza 
		mov  byte PTR znaki [11], 0AH ; kod nowego wiersza

	 ; wyœwietlenie cyfr na ekranie 
	push  dword PTR 12 ; liczba wyœwietlanych znaków 
	push  dword PTR OFFSET znaki ; adres wyœw. obszaru 
	push  dword PTR 1; numer urz¹dzenia (ekran ma numer 1) 
	call  __write  ; wyœwietlenie liczby na ekranie 
	add  esp, 12  ; usuniêcie parametrów ze stosu

	popa 
	ret 
wyswietl_EAX ENDP

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

policz_kwadrat_EAX PROC
	; zapamiêteanie na stosie u¿ytych rejestrów z wy³¹czeniem EAX (w nim znajduje siê wynik) oraz ESP
	push edx

	; liczenie kwadratu z rejestru EAX
	mul eax

	; zdjêcie zapisanych rejestrów ze stosu
	pop edx
	ret
policz_kwadrat_EAX ENDP
 
_main PROC 
	; wczytywanie liczby do rejestry EAX w celu jej pomno¿enia
	call wczytaj_do_EAX

	; liczenie kwadratu liczby
	call policz_kwadrat_EAX

	; wyswietlenie liczby
	call wyswietl_EAX

	; zakonczenie dzialania programu
	push 0 
	call _ExitProcess@4 
_main ENDP 
END