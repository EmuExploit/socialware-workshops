all: main.o
	ld -o main main.o
main.o: src.S
	nasm -felf64 src.S -o main.o

clean:
	rm -rf main*
