riscv64-elf-gcc -O0 -ggdb -nostdlib -march=rv32i -mabi=ilp32 -Wl,-Tasm.ld ./asm.s -o main.elf
riscv64-elf-objcopy -O binary main.elf main.bin // coby only the instruction part and not the info for debugging
xxd -e -c 4 -g 4 main.bin // print out the instruction in binary
qemu-system-riscv32 -S -M virt -nographic -bios none -kernel main.elf -gdb tcp::1234
gdb main.elf -ex "target remote localhost:1234" -ex "break _start" -ex "continue" -q

