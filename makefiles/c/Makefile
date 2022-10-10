MAKEFLAGS += --silent

files := $(shell find . -name '*.c')
# target := exit

.PHONY: all run check clean exit
all: check run

check:
ifeq ($(files),)
	echo '#include <stdio.h>\n\nint main() {\n  printf("Hola mundo\\n");\n  return 0;\n}' > main.c
	echo 'main.c creado'
files := main.c
endif

run: $(target)
	echo ./$(target)

$(target): $(files)
	gcc -Wall $(files) -o $(target)

clean:
	rm -rf $(target)
