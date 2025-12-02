.DELETE_ON_ERROR:
.PHONY: clean all

all: day1 day1-part2

clean:
	rm -f day1

day1: day1.s
	nasm -g -f elf64 $^
	ld -o day1.elf day1.o

day1-part2: day1-part2.s
	nasm -g -f elf64 $^
	ld -o day1-part2.elf day1-part2.o
