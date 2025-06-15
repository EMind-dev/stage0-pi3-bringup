/* ============================================================================
 * Example C code showing UART usage
 * 
 * This demonstrates how to use the UART driver from C code.
 * Note: You'll need to update the makefile to include C compilation
 * ========================================================================== */

#include "include/fw_types.h"
#include "include/uart/uart.h"

static void uart_demo(void);
static void c_kernel_main(void);
const u8_t demo_program_message[] = {
    (u8_t)'U', (u8_t)'A', (u8_t)'R', (u8_t)'T', (u8_t)' ',
    (u8_t)'D', (u8_t)'e', (u8_t)'m', (u8_t)'o', (u8_t)' ',
    (u8_t)'P', (u8_t)'r', (u8_t)'o', (u8_t)'g', (u8_t)'r', 
    (u8_t)'a', (u8_t)'m', (u8_t)'\r', (u8_t)'\n', 0U
};

const u8_t hello_message[] = {
    (u8_t)'H', (u8_t)'e', (u8_t)'l', (u8_t)'l', (u8_t)'o', 
    (u8_t)' ', (u8_t)'f', (u8_t)'r', (u8_t)'o', (u8_t)'m', 
    (u8_t)' ', (u8_t)'C', (u8_t)' ', (u8_t)'c', (u8_t)'o', 
    (u8_t)'d', (u8_t)'e', (u8_t)'!', (u8_t)'\r', (u8_t)'\n', 0U
};

const u8_t hex_message[] = {
    (u8_t)' ', (u8_t)'S', (u8_t)'e', (u8_t)'n', (u8_t)'d', 
    (u8_t)'i', (u8_t)'n', (u8_t)'g', (u8_t)' ', (u8_t)'h', 
    (u8_t)'e', (u8_t)'x', (u8_t)' ', (u8_t)'v', (u8_t)'a', 
    (u8_t)'l', (u8_t)'u', (u8_t)'e', (u8_t)':', (u8_t)' ', 0U
};

const u8_t starting_echo_mode_message[] = {
    (u8_t)'S', (u8_t)'t', (u8_t)'a', (u8_t)'r', (u8_t)'t', 
    (u8_t)'i', (u8_t)'n', (u8_t)'g', (u8_t)' ', (u8_t)'e', 
    (u8_t)'c', (u8_t)'h', (u8_t)'o', (u8_t)' ', (u8_t)'m', 
    (u8_t)'o', (u8_t)'d', (u8_t)'e', (u8_t)' ', (u8_t)'(', 
    (u8_t)'p', (u8_t)'r', (u8_t)'e', (u8_t)'s', (u8_t)'s', 
    (u8_t)' ', (u8_t)'a', (u8_t)'n', (u8_t)'y', (u8_t)' ', 
    (u8_t)'k', (u8_t)'e', (u8_t)'y', (u8_t)')', (u8_t)':', 
    (u8_t)'\r', (u8_t)'\n', 0U
};

const u8_t non_printable_message[] = {
    (u8_t)'\r', (u8_t)'\n', (u8_t)'[', (u8_t)'N', (u8_t)'o', 
    (u8_t)'n', (u8_t)'-', (u8_t)'p', (u8_t)'r', (u8_t)'i', 
    (u8_t)'n', (u8_t)'t', (u8_t)'a', (u8_t)'b', (u8_t)'l', 
    (u8_t)'e', (u8_t)' ', (u8_t)'c', (u8_t)'h', (u8_t)'a', 
    (u8_t)'r', (u8_t)'a', (u8_t)'c', (u8_t)'t', (u8_t)'e', 
    (u8_t)'r', (u8_t)' ', (u8_t)'r', (u8_t)'e', (u8_t)'c', 
    (u8_t)'e', (u8_t)'i', (u8_t)'v', (u8_t)'e', (u8_t)'d', 
    (u8_t)' ', (u8_t)']', (u8_t)'\r', (u8_t)'\n', 0U
};

const u8_t carriage_return_message[] = {
    (u8_t)'\r', (u8_t)'\n', 0U
};

const u8_t exiting_echo_mode_message[] = {
    (u8_t)'\r', (u8_t)'\n', (u8_t)'E', (u8_t)'x', (u8_t)'i', 
    (u8_t)'t', (u8_t)'i', (u8_t)'n', (u8_t)'g', (u8_t)' ', 
    (u8_t)'e', (u8_t)'c', (u8_t)'h', (u8_t)'o', (u8_t)' ', 
    (u8_t)'m', (u8_t)'o', (u8_t)'d', (u8_t)'e', (u8_t)'.', 
    (u8_t)'\r', (u8_t)'\n', 0U
};
/* ============================================================================
 * uart_demo - Demonstrates UART functionality
 * 
 * This function shows basic UART operations including string output,
 * hexadecimal display, and interactive character echo mode.
 * ========================================================================== */
static void uart_demo(void) {
    u8_t received_char = '\0';
    s32_t data_available = 0;
    u8_t exit_requested = false;
    /* Send message demo */
    uart_send_string(demo_program_message);
    /* Send a welcome message */
    uart_send_string(hello_message);
    
    /* Send some debug information */
    uart_send_string(hex_message);
    uart_send_hex(0xDEADBEEFUL);
    uart_send_string(carriage_return_message);
    
    /* Interactive loop - echo received characters */
    uart_send_string(starting_echo_mode_message);
    
    while (false == exit_requested)
    {
        data_available = uart_available();
        if (data_available != 0L)
        {
            received_char = uart_recv_char();
            if ((received_char == 'q') || (received_char == 'Q')) 
            {
                uart_send_string(exiting_echo_mode_message);
                exit_requested = true;
            }
            else            
            {
                uart_send_char(received_char);  /* Echo the received character */
                /* Handle character based on type using switch-case */
                switch (received_char)
                {
                    case '\r':
                    case '\n':
                        uart_send_string("\r\n");  /* Send newline for carriage return/line feed */
                        break;
                        
                    case '\b':
                        uart_send_string("\b \b");  /* Handle backspace */
                        break;
                        
                    case '\t':
                        uart_send_string("    ");  /* Handle tab - send spaces */
                        break;
                        
                    default:
                        if (received_char < NO_PRINTABLE_CHAR_LOW_END_ASCII || received_char > NO_PRINTABLE_CHAR_HIGH_END_ASCII)
                        {
                            uart_send_string(non_printable_message);
                        }
                        else
                        {
                            uart_send_char(received_char);  /* Echo printable characters */
                        }
                        break;
                }
            }


            

        }
    }
}

