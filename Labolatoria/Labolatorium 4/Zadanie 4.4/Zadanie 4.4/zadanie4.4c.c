#include <stdio.h>

void przestaw(int tabl[], int n);

int main()
{
	int n = 0;
	int tablica[11] = { 0 };

	printf("Prosze podac ilosc liczb:\n");
	scanf_s("%d", &n, 32);

	printf("\nProsze podac liczby:\n");

	for (int i = 0; i < n; i++)
	{
		scanf_s("%d", &tablica[i], 32);
	}

	for (int i = 0; i < n - 1; i++)
	{
		przestaw(tablica, n - i);
	}

	printf("\nWynik:\n");
	
	for (int i = 0; i < n; i++)
	{
		printf("%d\n", tablica[i]);
	}

	return 0;
}