.DELETE_ON_ERROR:
.PHONY: clean all

TARGET_DIR = target

all: $(TARGET_DIR)/day1 $(TARGET_DIR)/day1-part2 $(TARGET_DIR)/day3 $(TARGET_DIR)/day3-part2

clean:
	rm -f $(TARGET_DIR)

$(TARGET_DIR)/day1: day1.s
	mkdir -p $(TARGET_DIR)
	nasm -g -f elf64 $^ -o $@.o 
	ld -o $@ $@.o

$(TARGET_DIR)/day1-part2: day1-part2.s
	mkdir -p $(TARGET_DIR)
	nasm -g -f elf64 $^ -o $@.o 
	ld -o $@ $@.o

$(TARGET_DIR)/day3: day3.go
	mkdir -p $(TARGET_DIR)
	go build -o $@ $^

$(TARGET_DIR)/day3-part2: day3-part2.go
	mkdir -p $(TARGET_DIR)
	go build -o $@ $^
