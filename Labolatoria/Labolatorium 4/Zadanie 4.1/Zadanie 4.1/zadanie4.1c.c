#include <stdio.h> 

int szukaj_max(int a, int b, int c, int d);

int main()
{
	int x, y, z, j, wynik;
	printf("\nProsze podac cztery liczby calkowite ze znakiem:\n");
	scanf_s("%d  %d  %d %d", &x, &y, &z, &j, 32);
	wynik = szukaj_max(x, y, z, j);
	printf("\nSposrod podanych liczb %d, %d, %d, %d, liczba %d jest najwieksza\n", x,y,z,j, wynik); 
	return 0;
}