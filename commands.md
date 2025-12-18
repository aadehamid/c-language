riscv64-unknown-elf-gcc -O0 -ggdb -nostdlib -march=rv32i -mabi=ilp32 -Wl,-Tasm.ld ./asm.s -o main.elf
qemu-system-riscv32 -S -M virt -nographic -bios none -kernel main.elf -gdb tcp::1234 

