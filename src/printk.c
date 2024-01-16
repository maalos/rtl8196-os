#include "include/config.h"

void printk(char* str) {
	volatile char* uart_base = (volatile char*)(BASE_ADDRESS + COM1_OFFSET);

	while (*str != '\0') {
        	*uart_base = *str;
        	str++;
	}
}
