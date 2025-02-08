#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

// Dichiara le funzioni assembly
extern size_t ft_strlen(const char *str);
extern int ft_strcmp(const char *s1, const char *s2);
extern char *ft_strcpy(char *dest, const char *src);
extern ssize_t ft_write(int fd, const void *buf, size_t count);
extern char *ft_strdup(const char *s);
extern ssize_t ft_read(int fd, void *buf, size_t count);

void debug_print_hex(const char *msg, long val) {
    printf("%s: 0x%lx\n", msg, val);
}


int main(void) {
    // Test ft_strlen, ft_strcpy, ft_strcmp (esistenti)
    char *test = "Ciao Mondo!";
    size_t len = ft_strlen(test);
    printf("[ft_strlen] Lunghezza di '%s' = %zu\n", test, len);

    char buffer[50];
    ft_strcpy(buffer, test);
    printf("[ft_strcpy] Copia di '%s' => '%s'\n", test, buffer);

    int cmp = ft_strcmp("Hello", "Hello");
    printf("[ft_strcmp] 'Hello' vs 'Hello' => %d\n", cmp);

    cmp = ft_strcmp("abc", "abd");
    printf("[ft_strcmp] 'abc' vs 'abd' => %d\n", cmp);

    // Test ft_write
    char *write_str = "Test di ft_write!\n";
    ssize_t bytes = ft_write(1, write_str, ft_strlen(write_str));
    printf("[ft_write] Bytes scritti: %zd\n", bytes);

    // Test ft_strdup
    char *original = "Stringa da duplicare!";
    char *duplicate = ft_strdup(original);
    printf("[ft_strdup] Originale: '%s'\n", original);
    printf("[ft_strdup] Duplicato: '%s'\n", duplicate);
    free(duplicate);

    // Test ft_read
    int fd = open("test.txt", O_RDONLY);
    if (fd == -1) {
        perror("open");
        return 1;
    }
    char read_buffer[100];
    ssize_t read_bytes = ft_read(fd, read_buffer, sizeof(read_buffer) - 1);
    if (read_bytes == -1) {
        perror("ft_read");
    } else {
        read_buffer[read_bytes] = '\0';
        printf("[ft_read] Letti %zd bytes: '%s'\n", read_bytes, read_buffer);
    }
    close(fd);

    return 0;
}