NAME = libasm.a
SRC = ft_strlen.s
OBJ_DIR = obj/
OBJ = $(addprefix $(OBJ_DIR), $(SRC:.s=.o))

all: $(NAME)

$(NAME): $(OBJ)
	ar rcs $(NAME) $(OBJ)

$(OBJ_DIR)%.o: %.s | $(OBJ_DIR)
	nasm -f elf64 $< -o $@

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

clean:
	rm -rf $(OBJ_DIR)

fclean: clean
	rm -f $(NAME)

re: fclean all

.PHONY: all clean fclean re