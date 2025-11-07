.686 
.model flat 
extern __write : PROC 
extern _ExitProcess@4 : PROC 
public _main 

.data 
znaki   db 12 dup (?)

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
 
_main PROC 
	; zliczanie i wyswietlanie kolejnych wyrazow ciagu 

	; przygotowanie poczatkowych wartosci w rejestrach
	mov ecx, 50 ; liczba wyrazow do wygerownania
	mov ebx, 0  ; o ile zwiekszac wyraz ciagu
	mov eax, 1  ; pierwszy wyraz ciagu
	licz_znaki:
		add eax, ebx ; tworzenie kolejnego wyrazu ciagu
		inc ebx		 ; przygotwanie ebx do nastepnego zwiekszenia
		dec ecx		 ; zmniejszanie ilosci wyrazow do obliczenia
		call wyswietl_EAX ; wywolanie funkcji wysietl eax w celu wyswietlenia wyrazu ciagu
		cmp ecx, 0		  ; sprawdzenie czy wypisalismy wszystkie wyrazy ciagu
		jnz licz_znaki	  ; jezeli zostaly wyrazy ciagu do wypisywania to kontunujemy dzialanie "petli"
	
	; zakonczenie dzialania programu
	push 0 
	call _ExitProcess@4 
_main ENDP 
END