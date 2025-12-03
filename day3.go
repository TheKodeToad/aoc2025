package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	const inputName = "input/day3.txt"

	file, err := os.Open(inputName)
	if err != nil {
		panic(fmt.Errorf("could not open the puzzle input: %w", err))
	}

	scanner := bufio.NewScanner(file)

	var total int
	var bankNo int

	for scanner.Scan() {
		line := scanner.Text()

		bankNo++
		var bank []uint8

		for _, ch := range line {
			if ch < '0' || ch > '9' {
				panic(fmt.Sprintf("not a valid digit: %c", ch))
			}

			bank = append(bank, uint8(ch - '0'))
		}

		joltage := calcJoltage(bank)
		fmt.Printf("joltage of bank #%d: %d\n", bankNo, joltage)

		total += int(joltage)
		fmt.Printf("total: %d\n", total)
	}
}

func calcJoltage(bank []uint8) uint8 {
	var result uint8

	for leftIndex, left := range bank {
		for _, right := range bank[leftIndex+1:] {
			combined := left*10 + right

			if combined > result {
				result = combined
			}
		}
	}

	return result
}
