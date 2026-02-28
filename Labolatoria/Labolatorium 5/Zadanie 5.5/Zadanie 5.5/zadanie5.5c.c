#include <stdio.h> 

void pm_jeden(float* tablica);

int main()
{
	float tablica[4] = { 27.5, 143.57, 2100.0, -3.51 };

	printf("\nPrzykladowe liczby:\n%f   %f   %f   %f\n", tablica[0], tablica[1], tablica[2], tablica[3]);

	pm_jeden(tablica);

	printf("\nLiczby po wykonaniu operacji:\n%f   %f   %f   %f\n", tablica[0], tablica[1], tablica[2], tablica[3]);

	return 0;
}