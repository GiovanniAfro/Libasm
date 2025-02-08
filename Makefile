NAME = libasm.a
SRC = ft_strlen.s ft_strcmp.s ft_strcpy.s ft_write.s ft_strdup.s ft_read.s
OBJ_DIR = obj/
OBJ = $(addprefix $(OBJ_DIR), $(SRC:.s=.o))
CC = gcc
CFLAGS = -Wall -Wextra -Werror

all: $(NAME)

$(NAME): $(OBJ)
	ar rcs $(NAME) $(OBJ)

$(OBJ_DIR)%.o: %.s | $(OBJ_DIR)
	nasm -f elf64 -F dwarf -g $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

main.o: main.c
	$(CC) $(CFLAGS) -c main.c -o main.o

test: $(NAME) main.o
	$(CC) $(CFLAGS) main.o -L. -lasm -o test

clean:
	rm -rf $(OBJ_DIR) main.o

fclean: clean
	rm -f $(NAME) test

re: fclean all

.PHONY: all clean fclean re test