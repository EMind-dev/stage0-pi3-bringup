/* ============================================================================
 * Example C code showing UART usage
 * 
 * This demonstrates how to use the UART driver from C code.
 * Note: You'll need to update the makefile to include C compilation
 * ========================================================================== */
#include "../include/uart_LL.h"
#include "../include/types_emind.h"

    /* Constants defined to avoid magic numbers */
const u16_t hex_value = 0xCAFEU;
const u8_t* message = (const u8_t*)"Hello from C code!\r\n";
const u8_t* message_sending_hex = (const u8_t*)"Sending hex value: ";
const u8_t* newline = (const u8_t*)"\r\n";
const u8_t  space_character = ' ';
u8_t* bss_start = &__bss_start[0];
u8_t* bss_end   = &__bss_end[0];
u8_t* bss_size  = &__bss_size[0];
u8_t example_array[EXAMPLE_ARRAY_SIZE];
/**
 * @brief Demonstrates UART functionality from C code.
 * 
 * This function shows basic UART operations including string output,
 * hexadecimal display.
 * 
 * @return void
 */
void uart_send(void)
{
    /* All local variables declared and initialized at the beginning */


    uart_send_string(message);

    uart_send_string(message_sending_hex);
    uart_send_hex(hex_value);
    uart_send_string(newline);
    // Send the linker script section sizes
    uart_send_string((const u8_t*)"BSS size: ");
    uart_send_hex((u32_t)__bss_size);
    uart_send_string(newline);

    uart_send_string((const u8_t*)"BSS start: ");
    uart_send_hex((u32_t)&__bss_start);
    uart_send_string(newline);

    uart_send_string((const u8_t*)"BSS end: ");
    uart_send_hex((u32_t)&__bss_end);
    uart_send_string(newline);


    //Just to demonstrate BSS section usage this array is initialized to 0xFF
    //This is not a good practice in production code, but for demonstration purposes, it shows
    //how the BSS section works.
    for (u32_t i = 0; i < EXAMPLE_ARRAY_SIZE; i++) {
        uart_send_hex((u32_t)example_array[i]);
        uart_send_char(space_character);
    }
    uart_send_string(newline);

}


