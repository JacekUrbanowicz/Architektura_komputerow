#include <stdio.h>

float nowy_exp(float x);

int main()
{
	float x = 0;

	printf("Prosze podac podstawe ciagu:\n");
	scanf_s("%f", &x, 32);

	float wartosc_ciagu = nowy_exp(x);

	printf("\nWynik:\n%f\n", wartosc_ciagu);

	return 0;
}