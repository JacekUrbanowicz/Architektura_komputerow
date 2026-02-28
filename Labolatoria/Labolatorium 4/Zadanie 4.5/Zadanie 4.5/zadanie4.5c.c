#include <stdio.h> 
extern __int64 suma_siedmiu_liczb(__int64  v1, __int64  v2, __int64 v3, __int64  v4, __int64  v5, __int64  v6, __int64  v7);

int main()
{
    __int64 v1 = 0, v2 = 0, v3 = 0, v4 = 0, v5 = 0, v6 = 0, v7 = 0;

    printf("Prosze podac 7 liczb:\n");

    scanf_s("%I64d", &v1);
    scanf_s("%I64d", &v2);
    scanf_s("%I64d", &v3);
    scanf_s("%I64d", &v4);
    scanf_s("%I64d", &v5);
    scanf_s("%I64d", &v6);
    scanf_s("%I64d", &v7);

    __int64 wartosc_suma = suma_siedmiu_liczb (v1, v2, v3, v4, v5, v6, v7);

    printf("\nSuma podanych elementow wynosi:\n%I64d\n", wartosc_suma);
    return 0;
}