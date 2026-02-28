#include <stdio.h> 

void int2float(int* liczby_calkowite, float* liczby_zmienno_przecinkowe);

int main()
{
	int liczby_calkowite[2] = { -17, 24 };
	float liczby_zmienno_przecinkowe[4] = { 0 };

	printf("\nPrzykladowe liczby:\n%d %d\n", liczby_calkowite[0], liczby_calkowite[1]);

	int2float(liczby_calkowite, liczby_zmienno_przecinkowe);

	printf("\nLiczby po konwersji:\n%f  %f\n", liczby_zmienno_przecinkowe[0], liczby_zmienno_przecinkowe[1]);

	return 0;
}