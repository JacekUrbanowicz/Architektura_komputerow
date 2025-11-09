; wczytywanie liczby dziesiêtnej z klawiatury – po 
; wprowadzeniu cyfr nale¿y nacisn¹æ klawisz Enter 
 
; liczba po konwersji na postaæ binarn¹ zostaje wpisana 
; do rejestru EAX 

.686 
.model flat 
extern __read : PROC 
extern _ExitProcess@4 : PROC 
public _main 
 
.data 
obszar  db 12 dup (?) ; deklaracja tablicy do przechowywania wprowadzanych cyfr 
dziesiec  dd 10       ; mno¿nik

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

_main PROC
    ; wywo³anie wczytywania do eax
    call wczytaj_do_EAX

    ; zakonczenie dzialania programu
    push 0 
	call _ExitProcess@4 
_main ENDP 
END