.section ".text.boot"
.global _start
_start:
    //read cpu id, stop slave cores
    mrs x1, mpidr_el1
    and x1, x1, #0x3
    cbz x1, _init
    // cpu id > 0, stop

_halt_secondary_cores:
    wfe
    b _halt_secondary_cores
_init:
// Jump to init_system
    bl init_system
// Init the UART for debugging
    bl uart_init
    dsb sy
    isb


    // If kernel_main returns, enter an infinite loop

kernel_init:
    //bl main
    // Initialize the UART for debugging
  
    adrp x0, welcome_msg
    add x0, x0, :lo12:welcome_msg
    bl uart_send_string
    
    // Send system information
    adrp x0, system_info_msg
    add x0, x0, :lo12:system_info_msg
    bl uart_send_string
    
    // Send current exception level
    mrs x0, CurrentEL
    lsr x0, x0, #2             // Shift right by 2 to get EL value
    bl uart_send_hex
    
    adrp x0, newline_msg
    add x0, x0, :lo12:newline_msg
    bl uart_send_string
    
    // Send a completion message
    adrp x0, init_complete_msg
    add x0, x0, :lo12:init_complete_msg
    bl uart_send_string

    // Jump to the main kernel function
    b main // We should block in an infinite loop if main returns
    // If main returns, we halt the system
_halt_after_main:
    wfe
    b _halt_after_main
.section ".rodata"
welcome_msg:
    .asciz "Pi3 Stage0 Bootloader - UART Initialized\r\n"
system_info_msg:
    .asciz "Current Exception Level: "
newline_msg:
    .asciz "\r\n"
init_complete_msg:
    .asciz "System initialization complete. Jump to main...\r\n"
