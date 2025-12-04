.DELETE_ON_ERROR:
.PHONY: clean all

TARGET_DIR = target

all: $(TARGET_DIR)/day1 $(TARGET_DIR)/day1-part2 $(TARGET_DIR)/day2.class $(TARGET_DIR)/day2-part2.class $(TARGET_DIR)/day3 $(TARGET_DIR)/day3-part2 $(TARGET_DIR)/day4 $(TARGET_DIR)/day4-part2

clean:
	rm -rf $(TARGET_DIR)

$(TARGET_DIR)/day1: day1.s
	mkdir -p $(TARGET_DIR)
	nasm -g -f elf64 $^ -o $@.o 
	ld -o $@ $@.o

run-day1: $(TARGET_DIR)/day1
	$^

$(TARGET_DIR)/day1-part2: day1-part2.s
	mkdir -p $(TARGET_DIR)
	nasm -g -f elf64 $^ -o $@.o 
	ld -o $@ $@.o

run-day1-part2: $(TARGET_DIR)/day1-part2
	$^

$(TARGET_DIR)/day2.class: day2.kt
	kotlinc -Xno-call-assertions -Xno-param-assertions -Xno-receiver-assertions $^ -d target

run-day2: $(TARGET_DIR)/day2.class
	java -cp target day2

$(TARGET_DIR)/day2-part2.class: day2-part2.kt
	kotlinc -Xno-call-assertions -Xno-param-assertions -Xno-receiver-assertions $^ -d target

run-day2-part2: $(TARGET_DIR)/day2-part2.class
	java -cp target day2-part2

$(TARGET_DIR)/day3: day3.go
	mkdir -p $(TARGET_DIR)
	go build -o $@ $^

run-day3: $(TARGET_DIR)/day3
	$^

$(TARGET_DIR)/day3-part2: day3-part2.go
	mkdir -p $(TARGET_DIR)
	go build -o $@ $^

run-day3-part2: $(TARGET_DIR)/day3-part2
	$^

$(TARGET_DIR)/day4: day4.go
	mkdir -p $(TARGET_DIR)
	go build -o $@ $^

run-day4: $(TARGET_DIR)/day4
	$^

$(TARGET_DIR)/day4-part2: day4-part2.go
	mkdir -p $(TARGET_DIR)
	go build -o $@ $^

run-day4-part2: $(TARGET_DIR)/day4-part2
	$^
