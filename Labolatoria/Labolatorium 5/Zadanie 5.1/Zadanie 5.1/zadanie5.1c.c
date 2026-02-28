#include <stdio.h>

float srednia_harm(float* tablica, unsigned int n);

int main()
{
	unsigned int n = 0;
	float tablica[11] = { 0 };
	float* wskaznik = tablica;

	printf("Prosze podac ilosc liczb:\n");
	scanf_s("%d", &n, 32);

	printf("\nProsze podac liczby:\n");

	for (int i = 0; i < n; i++)
	{
		scanf_s("%f", &tablica[i], 32);
	}

	float wartosc_srednia = srednia_harm(wskaznik, n);

	printf("\nWynik:\n%f\n", wartosc_srednia);

	return 0;
}