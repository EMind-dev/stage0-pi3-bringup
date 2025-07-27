/* ============================================================================
 * Mini UART Driver for Raspberry Pi 3 (BCM2837)
 * 
 * This module provides initialization and basic I/O functions for the 
 * Mini UART peripheral via the AUX block.
 * ========================================================================== */

.include "startup/raspi_defs.s"

.section .text
.global uart_init
.global uart_send_char
.global uart_recv_char
.global uart_send_string
.global uart_send_hex
.global uart_available

/* ============================================================================
 * GPIO Register Definitions for UART pins
 * ========================================================================== */
.equ GPIO_BASE,              (PERIPHERAL_BASE + 0x200000)
.equ GPFSEL1,               (GPIO_BASE + 0x04)      // GPIO Function Select 1
.equ GPPUD,                 (GPIO_BASE + 0x94)      // GPIO Pull-up/down
.equ GPPUDCLK0,             (GPIO_BASE + 0x98)      // GPIO Pull-up/down Clock Register 0

/* ============================================================================
 * UART Control Bit Definitions
 * ========================================================================== */
.equ MU_ENABLE_BIT,         1                       // Bit 0 in AUX_ENABLES
.equ MU_TX_ENABLE,          2                       // Bit 1 in MU_CNTL
.equ MU_RX_ENABLE,          1                       // Bit 0 in MU_CNTL
.equ MU_TX_EMPTY,           0x20                    // Bit 5 in MU_LSR
.equ MU_RX_READY,           0x01                    // Bit 0 in MU_LSR

/* ============================================================================
 * uart_init - Initialize the Mini UART
 * 
 * Configures GPIO pins 14,15 for UART function and sets up the Mini UART
 * for 115200 baud, 8N1 (8 data bits, no parity, 1 stop bit)
 * 
 * Parameters: None
 * Returns: None
 * Modifies: x0, x1, x2, w1, w2
 * ========================================================================== */
uart_init:
    stp x29, x30, [sp, #-16]!  // Save frame pointer and link register
    movz x29, #0              // Initialize frame pointer
    add x29, sp, #0      // Set frame pointer to current stack pointer

    // Step 1: Enable Mini UART in AUX
    adrp x0, RASPI_AUX_ENABLES
    add x0, x0, :lo12:RASPI_AUX_ENABLES
    movz w1, #MU_ENABLE_BIT
    str w1, [x0]

    // Step 2: Disable UART during configuration
    adrp x0, RASPI_AUX_MU_CNTL
    add x0, x0, :lo12:RASPI_AUX_MU_CNTL
    movz w1, #0
    str w1, [x0]

    // Step 3: Disable interrupts
    adrp x0, RASPI_AUX_MU_IER
    add x0, x0, :lo12:RASPI_AUX_MU_IER
    movz w1, #0
    str w1, [x0]

    // Step 4: Clear and disable receive/transmit FIFOs
    adrp x0, RASPI_AUX_MU_IIR
    add x0, x0, :lo12:RASPI_AUX_MU_IIR
    movz w1, #0xC6              // Clear FIFOs (bits 7:6 = 11) + enable FIFOs (bits 2:1 = 11)
    str w1, [x0]

    // Step 5: Set 8-bit mode (8N1)
    adrp x0, RASPI_AUX_MU_LCR
    add x0, x0, :lo12:RASPI_AUX_MU_LCR
    movz w1, #3                 // 8-bit data (bits 1:0 = 11)
    str w1, [x0]

    // Step 6: Set RTS line to be always high
    adrp x0, RASPI_AUX_MU_MCR
    add x0, x0, :lo12:RASPI_AUX_MU_MCR
    movz w1, #0
    str w1, [x0]

    // Step 7: Set baud rate to 115200
    // Formula: baudrate_reg = (system_clock_freq / (8 * desired_baud)) - 1
    // For Pi 3: 250MHz / (8 * 115200) - 1 = 270.26... ≈ 270
    adrp x0, RASPI_AUX_MU_BAUD
    add x0, x0, :lo12:RASPI_AUX_MU_BAUD
    movz w1, #270
    strh w1, [x0]

    // Step 8: Configure GPIO pins 14 and 15 for UART (ALT5 function)
    adrp x0, GPFSEL1
    add x0, x0, :lo12:GPFSEL1
    ldr w1, [x0]
    bic w1, w1, #(7 << 12)     // Clear GPIO14 function (bits 14:12)
    bic w1, w1, #(7 << 15)     // Clear GPIO15 function (bits 17:15)
    orr w1, w1, #(2 << 12)     // Set GPIO14 to ALT5 (010)
    orr w1, w1, #(2 << 15)     // Set GPIO15 to ALT5 (010)
    str w1, [x0]

    // Step 9: Disable pull-up/pull-down on GPIO pins 14,15
    adrp x0, GPPUD
    add x0, x0, :lo12:GPPUD
    movz w1, #0                 // Disable pull-up/down
    str w1, [x0]

    // Wait 200 cycles for control signal to settle
    movz x2, #200
1:  subs x2, x2, #1
    b.ne 1b

    // Clock the control signal into the GPIO pads
    adrp x0, GPPUDCLK0
    add x0, x0, :lo12:GPPUDCLK0
    movz w1, #(1 << 14) | (1 << 15)  // Clock GPIO14 and GPIO15
    str w1, [x0]

    // Wait another 200 cycles
    movz x2, #200
2:  subs x2, x2, #1
    b.ne 2b

    // Remove the clock
    adrp x0, GPPUDCLK0
    add x0, x0, :lo12:GPPUDCLK0
    movz w1, #0
    str w1, [x0]

    // Step 10: Finally, enable the UART transmitter and receiver
    adrp x0, RASPI_AUX_MU_CNTL
    add x0, x0, :lo12:RASPI_AUX_MU_CNTL
    movz w1, #(MU_TX_ENABLE | MU_RX_ENABLE)
    str w1, [x0]

    ldp x29, x30, [sp], #16
    ret

/* ============================================================================
 * uart_send_char - Send a single character via UART
 * 
 * Parameters: w0 = character to send
 * Returns: None
 * Modifies: x1, w2
 * ========================================================================== */
uart_send_char:
    // x0 = byte to send (only low 8 bits matter)

    // --- poll LSR bit 5 until TX FIFO has space ---
    adrp    x1, RASPI_AUX_MU_LSR
    add     x1, x1, :lo12:RASPI_AUX_MU_LSR
1:  ldr     w2, [x1]
    tst     w2, #0x20          // bit 5 set?
    beq     1b

    // --- write the character (32-bit store) ---
    adrp    x1, RASPI_AUX_MU_IO
    add     x1, x1, :lo12:RASPI_AUX_MU_IO
    str     w0, [x1]

    ret

/* ============================================================================
 * uart_recv_char - Receive a single character via UART
 * 
 * Parameters: None
 * Returns: w0 = received character
 * Modifies: x1, w2
 * ========================================================================== */
uart_recv_char:
    // Wait for data to be available (RX FIFO not empty)
1:  adrp x1, RASPI_AUX_MU_LSR
    add x1, x1, :lo12:RASPI_AUX_MU_LSR
    ldr w2, [x1]
    and w2, w2, #MU_RX_READY   // Check if data is ready
    cmp w2, #0
    b.eq 1b                    // If no data, keep waiting

    // Read the character
    adrp x1, RASPI_AUX_MU_IO
    add x1, x1, :lo12:RASPI_AUX_MU_IO
    ldr w0, [x1]
    and w0, w0, #0xFF          // Ensure only 8 bits
    ret

/* ============================================================================
 * uart_available - Check if data is available to read
 * 
 * Parameters: None
 * Returns: w0 = 1 if data available, 0 if not
 * Modifies: x1, w2
 * ========================================================================== */
uart_available:
    adrp x1, RASPI_AUX_MU_LSR
    add x1, x1, :lo12:RASPI_AUX_MU_LSR
    ldr w2, [x1]
    and w0, w2, #MU_RX_READY   // Check if data is ready
    cmp w0, #0
    cset w0, ne                // Set w0 to 1 if not equal (data available)
    ret

/* ============================================================================
 * uart_send_string - Send a null-terminated string via UART
 * 
 * Parameters: x0 = pointer to null-terminated string
 * Returns: None
 * Modifies: x19, w0 (through uart_send_char)
 * ========================================================================== */
uart_send_string:
    stp x29, x30, [sp, #-32]!  // Save frame pointer, link register, and x19
    stp x19, xzr, [sp, #16]
    mov x29, sp
    
    mov x19, x0                // Save string pointer

1:  ldrb w0, [x19], #1        // Load byte and increment pointer
    cbz w0, 2f                 // If character is 0, end of string
    bl uart_send_char          // Send the character
    b 1b                       // Continue with next character
    
2:  ldp x19, xzr, [sp, #16]   // Restore x19
    ldp x29, x30, [sp], #32    // Restore frame pointer and link register
    ret

/* ============================================================================
 * uart_send_hex - Send a 64-bit value as hexadecimal string
 * 
 * Parameters: x0 = 64-bit value to send as hex
 * Returns: None
 * Modifies: x19, x20, x21, w0 (through uart_send_char)
 * ========================================================================== */
uart_send_hex:
    stp x29, x30, [sp, #-48]!  // Save registers
    stp x19, x20, [sp, #16]
    stp x21, xzr, [sp, #32]
    mov x29, sp
    
    mov x19, x0                // Save the value
    movz x20, #60              // Start with bit position 60 (15*4)
    
    // Send "0x" prefix
    movz w0, #'0'
    bl uart_send_char
    movz w0, #'x'
    bl uart_send_char

1:  lsr x21, x19, x20          // Shift right by bit position
    and x21, x21, #0xF         // Get lowest 4 bits
    
    cmp x21, #10               // Compare with 10
    b.lt 2f                    // If < 10, it's a digit
    
    // It's A-F
    add w0, w21, #'A' - 10
    b 3f
    
2:  // It's 0-9
    add w0, w21, #'0'
    
3:  bl uart_send_char          // Send the character
    
    cmp x20, #0                // Check if we're done
    b.eq 4f                    // If bit position is 0, we're done
    sub x20, x20, #4           // Move to next nibble
    b 1b
    
4:  ldp x21, xzr, [sp, #32]   // Restore registers
    ldp x19, x20, [sp, #16]
    ldp x29, x30, [sp], #48
    ret
