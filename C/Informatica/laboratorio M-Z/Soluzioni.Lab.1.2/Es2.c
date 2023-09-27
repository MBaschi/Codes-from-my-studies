#include <stdio.h>

int main(int argc, const char * argv[])
{
    float zeroAssolutoCelsius = -273.15;
    float celsius, fahrenheit, kelvin;
    printf ("Inserire temperatura in °C:");
    scanf ("%f", &celsius);
    if (celsius >= zeroAssolutoCelsius)
    {
        fahrenheit = (9.0 / 5.0) * celsius + 32;
        kelvin = celsius - zeroAssolutoCelsius;
        printf ("Fahrenheit: %0.2f, Kelvin: %0.2f\n", fahrenheit, kelvin);
    } else {
        printf ("Errore: temperatura minore dello zero assoluto!\n");
    }
}
