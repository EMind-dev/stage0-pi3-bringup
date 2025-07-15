/* ============================================================================
 * Example C code showing UART usage
 * 
 * This demonstrates how to use the UART driver from C code.
 * Note: You'll need to update the makefile to include C compilation
 * ========================================================================== */
#include "../include/uart_LL.h"
#include "../include/types_emind.h"
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
    u8_t received_char = 0U;
    s32_t data_available = 0;
    u8_t exit_condition = 0U;

    /* Constants defined to avoid magic numbers */
    const u16_t hex_value = 0xCAFEU;
    const u8_t carriage_return = (u8_t)'\r';
    const u8_t newline = (u8_t)'\n';
    const u8_t quit_lower = (u8_t)'q';
    const u8_t quit_upper = (u8_t)'Q';

    uart_send_string((const u8_t*)"Hello from C code!\r\n");
    
    uart_send_string((const u8_t*)"Sending hex value: ");
    uart_send_hex(hex_value);
    uart_send_string((const u8_t*)"\r\n");
    
}


