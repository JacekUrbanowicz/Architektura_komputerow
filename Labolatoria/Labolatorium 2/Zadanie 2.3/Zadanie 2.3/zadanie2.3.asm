; Wywo³anie funckji MassegeBoxW z komunikatem
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
public _main

; Segment danych
.data
tytul_MessageBoxa dw 'Z', 'n', 'a', 'k', 'i', 0

tresc_MessageBoxa dw 'T', 'o', ' ', 'j', 'e', 's', 't', ' ', 'm', 'i', 's', 'i', 'a', ' '
				  dw 0D83Dh, 0DC31h ; Emotka kota
				  dw ' '
				  dw 0D83Dh, 0DC08h ; Druga emotka kota
				  dw ' ', 'i', ' ', 'J', 'a', 'c', 'e', 'k', ' ', 'n', 'a', ' ', 's', 'p', 'a'
				  dw 'c', 'e', 'r', 'z', 'e', ' ', 'z', ' ', 'n', 'i'
				  dw 0105h ; szesnastkowa literka ¹
				  dw ' '
				  dw 0D83Dh, 0DE00h, 0 ; Emotka usmiechnietej buzki

; Segment rozkazow
.code
_main PROC

	; Pushowanie parametrow
	push 0 ; MB_OK czyli opcje okna
	push OFFSET tytul_MessageBoxa ; Tytul MessageBoxa
	push OFFSET tresc_MessageBoxa ; Tresc MessageBoxa
	push 0 ; Hwnd = 0 czyli uchwyt okna
	call _MessageBoxW@16 ; Wywolanie funkcji MessageBoxW

	; Powrot z funkcji
	push 0
	call _ExitProcess@4

_main ENDP
END