# Makefile for MIPS kernel

LOADADDR=0x80000000
RAMSIZE=0x20000000

CROSS_COMPILE=mipsel-elf-
QEMU=qemu-system-mipsel -M mipssim -kernel out/kernel.elf

AS=$(CROSS_COMPILE)as
CC=$(CROSS_COMPILE)gcc
LD=$(CROSS_COMPILE)ld
OBJCOPY=$(CROSS_COMPILE)objcopy
OBJDUMP=$(CROSS_COMPILE)objdump

CFLAGS=-O -G 0 -mno-abicalls -fno-pic -Wall -DRAMSIZE=$(RAMSIZE) -Wextra -Werror -ffreestanding -nostdlib -fno-builtin -nostartfiles -nodefaultlibs -O2

# Drop some uninteresting sections in the kernel.
# This is only relevant for ELF kernels but doesn't hurt a.out
dropsections	=.reginfo .mdebug
stripflags	=$(addprefix --remove-section=,$(dropsections))

SRCDIR=src
OBJDIR=obj
OUTDIR=out

ASSEMBLY_SOURCE=$(SRCDIR)/entry.s
C_SOURCES=$(wildcard $(SRCDIR)/*.c)
OBJECTS=$(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(C_SOURCES))

all: kernel

$(OBJDIR)/entry.o: $(ASSEMBLY_SOURCE)
	$(AS) -o $@ $<

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	$(CC) -o $@ -c $< -std=gnu99 $(CFLAGS)

kernel: $(OBJDIR)/entry.o $(OBJECTS)
	$(LD) -T $(SRCDIR)/ldscript -o $(OUTDIR)/kernel.elf $^
	$(OBJCOPY) -S -O srec $(stripflags) $(OUTDIR)/kernel.elf $(OUTDIR)/kernel.srec
	$(OBJCOPY) -S -O binary $(stripflags) $(OUTDIR)/kernel.elf $(OUTDIR)/kernel.bin

run: kernel
	$(QEMU) -serial stdio

clean:
	rm -rf $(OBJDIR)/*.o $(OUTDIR)/*.elf $(OUTDIR)/*.srec $(OUTDIR)/*.bin
