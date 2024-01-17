#include <stdint.h>
#include <stddef.h>

#define MALTA 1

#include "include/config.h"
#include "include/printk.h"

size_t strlen(const char* str) {
	size_t len = 0;
	while (str[len])
		len++;
	return len;
}

char* strcat(char* dest, const char* src)
{
	size_t dest_len = strlen(dest);
	size_t i;

	for (i = 0; src[i] != '\0'; i++)
		dest[dest_len + i] = src[i];
	dest[dest_len + i] = '\0';

	return dest;
}

uint32_t getRegisterValue(char* registerName) // TODO: implement something beyond $ra
{
	uint32_t registerValue;
	asm volatile (
		      "move %0, %1" // this doesn't really work - "move %0, $%1"
		      : "=r" (registerValue)
		      : "r" (registerName)
	);

	return registerValue;
}

// qemu-system-mipsel -M malta -bios out/kernel.bin -serial stdio

void uint32ToHexStr(uint32_t value, char hexStr[9])
{
	const char hexDigits[] = "0123456789ABCDEF";
	hexStr[8] = '\0';

	for (int i = 7; i >= 0; i--) {
		hexStr[i] = hexDigits[value & 0xF];
		value >>= 4;
	}
}

#define UART_BASE ((volatile char*)(BASE_ADDRESS + COM1_OFFSET))

int is_serial_data_available() {
	return (*(UART_BASE + 1) & 1);
}

void kernel_main()
{
	printk("UART/COM1 at 0x");
	char uartAddress[9];
	uint32ToHexStr(BASE_ADDRESS + COM1_OFFSET, uartAddress);
	printk(uartAddress);
	printk("\nCompiled at ");
	printk(__TIME__);
	printk(" on ");
	printk(__DATE__);
	printk("\n\n\n");
	
	while (1) {
      		printk("# ");
		while (!is_serial_data_available());
	}
	//while (!is_serial_data_available());
	//printk("data!");
			
}
