all: main.o
	ld -o main main.o
main.o: src.S
	nasm -felf64 src.S

clean:
	rm -rf main*
