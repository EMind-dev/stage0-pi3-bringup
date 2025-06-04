.section ".text.boot"
.global _kernel_main

// External UART function declarations
.extern uart_send_string
.extern uart_send_hex
.extern uart_send_char

_kernel_main:
    // Send a welcome message via UART
    ldr x0, =welcome_msg
    bl uart_send_string
    
    // Send system information
    ldr x0, =system_info_msg
    bl uart_send_string
    
    // Send current exception level
    mrs x0, CurrentEL
    lsr x0, x0, #2             // Shift right by 2 to get EL value
    bl uart_send_hex
    
    ldr x0, =newline_msg
    bl uart_send_string
    
    // Send a completion message
    ldr x0, =init_complete_msg
    bl uart_send_string

1:  wfe                        // Wait for an event
    b 1b                       // Infinite loop

.section .rodata
welcome_msg:
    .asciz "Pi3 Stage0 Bootloader - UART Initialized\r\n"
system_info_msg:
    .asciz "Current Exception Level: "
newline_msg:
    .asciz "\r\n"
init_complete_msg:
    .asciz "System initialization complete. Entering wait loop.\r\n"