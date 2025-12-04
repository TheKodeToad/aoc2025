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
			if ch < '1' || ch > '9' {
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

func calcJoltage(bank []uint8) uint {
	remaining := 12

	if len(bank) < remaining {
		panic(fmt.Sprintf("not enough digits in bank: %d (need at least %d)", len(bank), remaining))
	}

	var result uint

	for i := 0; remaining > 0; {
		leeway := len(bank) - i - remaining

		// be greedy; go for the highest possible digit
		var highestDigit uint8

		end := i + leeway

		for j := i; j <= end; j++ {
			if bank[j] > highestDigit {
				i = j + 1
				highestDigit = bank[j]
			}
		}

		remaining--

		result *= 10
		result += uint(highestDigit)
	}

	return result
}
