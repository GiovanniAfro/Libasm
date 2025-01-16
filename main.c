#include <stdio.h>

size_t ft_strlen(const char *str);  // Dichiara la funzione

int main() {
    char *test = "Ciao Mondo!";
    size_t len = ft_strlen(test);
    printf("Lunghezza: %zu\n", len);
    return 0;
}