#ifndef MALTA // mipssim
#define BASE_ADDRESS 0xBFD00000
#else // malta, rtl8196c
#define BASE_ADDRESS 0xB8000000
#endif

#define COM1_OFFSET  0x000003F8
#define COM2_OFFSET  0x000002F8
