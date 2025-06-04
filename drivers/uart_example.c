/* ============================================================================
 * Example C code showing UART usage
 * 
 * This demonstrates how to use the UART driver from C code.
 * Note: You'll need to update the makefile to include C compilation
 * 
 * MISRA C Compliance:
 * - Functions have explicit prototypes
 * - All if/while statements use braces
 * - No unreachable code
 * - Explicit type conversions where needed
 * ========================================================================== */

/* MISRA 20.1: Include directives should be at the top */
#include <stdint.h>
#include "../include/uart.h"

/* MISRA 8.4: Function prototypes - visible at point of definition */
static void uart_demo(void);
static void c_kernel_main(void) __attribute__((noreturn));

/* ============================================================================
 * uart_demo - Demonstrates UART functionality
 * 
 * This function shows basic UART operations including string output,
 * hexadecimal display, and interactive character echo mode.
 * ========================================================================== */
static void uart_demo(void) {
    /* Send a welcome message */
    uart_send_string("Hello from C code!\r\n");
    
    /* Send some debug information */
    uart_send_string("Sending hex value: ");
    uart_send_hex(0xDEADBEEFUL);  /* MISRA 10.1: Explicit unsigned long literal */
    uart_send_string("\r\n");
    
    /* Interactive loop - echo received characters */
    uart_send_string("Starting echo mode (press any key):\r\n");
    
    /* MISRA 14.2/15.6: Infinite loop with explicit condition and braces */
    for (;;) {
        /* MISRA 17.7: Check return value from uart_available */
        int32_t data_available = uart_available();
        if (data_available != 0) {
            char received_char = uart_recv_char();
            
            /* Echo the character back */
            uart_send_char(received_char);
            
            /* Add newline if Enter was pressed */
            if (received_char == '\r') {
                uart_send_char('\n');
            }
            
            /* Exit on 'q' - MISRA 15.6: All if statements use braces */
            if ((received_char == 'q') || (received_char == 'Q')) {
                uart_send_string("\r\nExiting echo mode.\r\n");
                break;  /* MISRA 15.4: Explicit loop termination */
            }
        }
    }
}

/* ============================================================================
 * c_kernel_main - Alternative main function for C-based kernel
 * 
 * This function serves as an alternative entry point if you want to use
 * C instead of assembly for the main kernel logic.
 * 
 * MISRA Note: Function marked as noreturn to indicate infinite execution
 * Note: Function intentionally unused in current build configuration
 * ========================================================================== */
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-function"
static void c_kernel_main(void) {
    uart_demo();
    
    /* MISRA 14.2/15.6: Infinite loop with explicit condition and braces */
    /* MISRA 2.1: No unreachable code - function marked as noreturn */
    for (;;) {
        __asm__ volatile ("wfe" ::: "memory");  /* Wait for event with memory barrier */
    }
}
#pragma GCC diagnostic pop
