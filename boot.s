.section .text.boot
.global _start 
_start:
    // Set up the stack pointer
    mov x0, #0x8000
    lsl x0, x0, #16             // Shift left by 16 bits (0x80000000)
    mov sp, x0                  // Set stack pointer

    // Initialize the system
    bl init_system

