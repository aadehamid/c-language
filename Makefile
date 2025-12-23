# RISC-V Toolchain
CC = riscv64-elf-gcc
OBJCOPY = riscv64-elf-objcopy
CFLAGS = -O0 -ggdb -nostdlib -march=rv32i -mabi=ilp32
LDFLAGS = -Wl,-Tasm.ld

# Source files
SRCS = asm.s
TARGET = main.elf
BINARY = main.bin

# QEMU settings
QEMU = qemu-system-riscv32
QEMU_FLAGS = -M virt -nographic -bios none
GDB_PORT = 1234

.PHONY: all machinecode printbinary startqemu connectgdb clean

all: machinecode

machinecode: $(TARGET)

$(TARGET): $(SRCS) asm.ld
	$(CC) $(CFLAGS) $(LDFLAGS) ./$(SRCS) -o $(TARGET)

$(BINARY): $(TARGET)
	$(OBJCOPY) -O binary $(TARGET) $(BINARY)

printbinary: $(BINARY)
	xxd -e -c 4 -g 4 $(BINARY)

startqemu: $(TARGET)
	@echo "Starting QEMU in debug mode on port $(GDB_PORT)..."
	@echo "In another terminal, run: make connectgdb"
	$(QEMU) -S $(QEMU_FLAGS) -kernel $(TARGET) -gdb tcp::$(GDB_PORT)

connectgdb: $(TARGET)
	gdb $(TARGET) \
		-ex "set architecture riscv:rv32" \
		-ex "target remote localhost:$(GDB_PORT)" \
		-ex "break _start" \
		-ex "continue" \
		-q

clean:
	rm -f $(TARGET) $(BINARY)
