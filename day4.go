// no standard library allowed - only cgo!
// note: builtins are allowed - duh
// anything goes as long as only C is imported!

package main

/*
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct file_result {
	FILE *file;
	int err;
};

struct char_result {
	char ch;
	int err;
};

static struct file_result checked_fopen(const char *filename, const char *mode) {
	FILE *file = fopen(filename, mode);

	if (file != NULL)
		return (struct file_result) { file, 0 };
	else
		return (struct file_result) { NULL, errno };
}

static struct char_result checked_fgetc(FILE *file) {
	errno = 0;

	int ch_or_eof = fgetc(file);

	if (ch_or_eof != EOF)
		return (struct char_result) { (char) ch_or_eof, 0 };
	else
		return (struct char_result) { 0, errno };
}

static void print_int(const char *prefix, int i) {
	printf("%s%d\n", prefix, i);
}

*/
import "C"

func main() {
	rows := readInputMatrix()
	accessible := 0

	for row, _ := range rows {
		for col, _ := range rows[row] {
			if !rows[row][col] {
				continue
			}

			remaining := 4

			// not great but I've spent too long
			for adjRow := row - 1; adjRow <= row + 1; adjRow++ {
				for adjCol := col - 1; adjCol <= col + 1; adjCol++ {
					if adjRow == row && adjCol == col {
						continue
					}

					if adjRow < 0 || adjRow >= len(rows) {
						continue
					}

					if adjCol < 0 || adjCol >= len(rows[adjRow]) {
						continue
					}

					if rows[adjRow][adjCol] {
						remaining--
					}
				}

				if remaining <= 0 {
					break
				}
			}

			if remaining > 0 {
				accessible++
			}
		}
	}

	C.print_int(C.CString("accessible rolls: "), C.int(accessible))
}

func readInputMatrix() [][]bool {
	const inputFilename = "input/day4.txt"

	fileResult := C.checked_fopen(C.CString(inputFilename), C.CString("r")) // let it leak! memory is cheap
	if fileResult.err != 0 {
		panic("could not open " + inputFilename + ": " + C.GoString(C.strerror(fileResult.err)))
	}

	file := fileResult.file

	matrix := [][]bool{{}}

	chResult := C.checked_fgetc(file)

	for chResult.ch != 0 {
		ch := chResult.ch

		last := &matrix[len(matrix)-1]

		switch ch {
		case '@', '.':
			*last = append(*last, ch == '@')
		case '\n':
			if len(*last) == 0 {
				break
			}

			matrix = append(matrix, []bool{})
		default:
			panic("invalid char in input: " + string(ch))
		}

		chResult = C.checked_fgetc(file)
	}

	if chResult.err != 0 {
		panic("error reading " + inputFilename + ": " + C.GoString(C.strerror(chResult.err)))
	}

	last := matrix[len(matrix)-1]

	if len(last) == 0 {
		matrix = matrix[0:len(matrix)-1]
	}

	return matrix
}
