all: test iolib clean

iolib: iolib.o
	ld -o iolib iolib.o

iolib.o: iolib.asm
	nasm -felf64 iolib.asm -o iolib.o

.PHONY: clean

clean:
	rm -rf *.o