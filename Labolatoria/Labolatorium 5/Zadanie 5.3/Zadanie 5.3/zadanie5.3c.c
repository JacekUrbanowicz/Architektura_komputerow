#include <stdio.h> 

void suma_tablic(float* tablica1, float* tablica2, float* tablica3);

int main()
{
	char liczby_A[16] = 
	{ 
		-128, -127, -126, -125, -124, -123, -122, -121, 
		120,  121,  122,  123,  124,  125,  126, 127 
	};
	char liczby_B[16] = 
	{  
		-3, -3, -3, -3, -3, -3, -3, -3, 
		3,  3,  3,  3,  3,  3,  3,  3 
	};
	char liczby_wynik[16] = { 0 };

	printf("\nPrzykladowe liczby pierwszej tablicy:\n");

	for (int i = 0; i < 16; i++)
	{
		printf("%d ", liczby_A[i]);
	}

	printf("\n\nPrzykladowe liczby drugiej tablicy:\n");

	for (int i = 0; i < 16; i++)
	{
		printf(" %d  ", liczby_B[i]);
	}

	suma_tablic(liczby_A, liczby_B, liczby_wynik);

	printf("\n\nSuma tablic:\n");

	for (int i = 0; i < 16; i++)
	{
		printf("%d ", liczby_wynik[i]);
	}

	printf("\n");

	return 0;
}