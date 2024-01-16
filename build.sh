mipsel-elf-as -o obj/entry.o src/entry.s

for file in `cd src && find *.c`; do
	mipsel-elf-gcc -o obj/$file.o -c src/$file -std=c99 -Wall -Wextra -Werror -ffreestanding -nostdlib -fno-builtin -nostartfiles -nodefaultlibs -O2
done

mipsel-elf-ld -T src/ldscript -o out/kernel.elf obj/*.o

qemu-system-mipsel -M mipssim -kernel out/kernel.elf -serial stdio
