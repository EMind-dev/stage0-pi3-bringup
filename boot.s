.section .text.boot
.global _start 
_start:
    // Set up the stack pointer
    movz sp, #0x8000, lsl #16   // Set stack pointer to top of RAM shifted left by 16 bits

    // Initialize the system
    bl init_system

