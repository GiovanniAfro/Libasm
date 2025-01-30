#include <stdio.h>

// Dichiariamo le nostre funzioni assembly:
extern size_t ft_strlen(const char *str);
extern int    ft_strcmp(const char *s1, const char *s2);
extern char  *ft_strcpy(char *dest, const char *src);

int main(void) {
    // 1) Test ft_strlen
    char *test = "Ciao Mondo!";
    size_t len = ft_strlen(test);
    printf("[ft_strlen] Lunghezza di '%s' = %zu\n", test, len);

    // 2) Test ft_strcpy
    char buffer[50];
    ft_strcpy(buffer, test);
    printf("[ft_strcpy] Copia di '%s' => '%s'\n", test, buffer);

    // 3) Test ft_strcmp
    int cmp = ft_strcmp("Hello", "Hello");
    printf("[ft_strcmp] Confronto 'Hello' con 'Hello' => %d\n", cmp);

    cmp = ft_strcmp("abc", "abd");
    printf("[ft_strcmp] Confronto 'abc' con 'abd' => %d\n", cmp);

    return 0;
}
