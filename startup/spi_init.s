/* ===============================================================
 * SPI Initialization Code for Raspberry Pi 3 (BCM2837)
 *
 * This module provides the assembly code to initialize the SPI
 * interface.
 * ==========================================================================
 */


 .include "startup/raspi_defs.s"

 .section .text

.global spi_init
.global spi_send_byte
.global spi_recv_byte

spi_init:
    stp x29, x30, [sp, #-16]!  // Save frame pointer and link register
    movz x29, #0               // Initialize frame pointer
    add x29, sp, #0            // Set frame pointer to current stack pointer

    // Step 1: Enable SPI0 in AUX
    adrp x0, RASPI_AUX_ENABLES
    add x0, x0, :lo12:RASPI_AUX_ENABLES
    ldr w1, [x0]               // Read current value of the register
    orr w1, w1, #2             // Set bit 1 to enable SPI0
    str w1, [x0]               // Write back the updated value


    // Step 2: Configure SPI1 Control Register 0
    adrp x0, RASPI_AUX_SPI1_CNTL0
    add x0, x0, :lo12:RASPI_AUX_SPI1_CNTL0
    movz w1, #0x00000000          // Default settings (CPOL=0, CPHA=0) we are sampling on the rising edge
    str w1, [x0]

    // Step 3: Configure SPI1 Control Register 1
    adrp x0, RASPI_AUX_SPI1_CNTL1
    add x0, x0, :lo12:RASPI_AUX_SPI1_CNTL1
    mov w1, #0x00                // Default settings (8-bit mode)
    str w1, [x0]

    // Step 4: Clear any pending SPI interrupts
    adrp x0, RASPI_AUX_SPI1_STAT
    add x0, x0, :lo12:RASPI_AUX_SPI1_STAT
    mov w1, #0xFFFFFFFF          // Clear all status bits
    str w1, [x0]

    // Step 5: Enable SPI in the control register
    adrp x0, RASPI_AUX_SPI1_CNTL1
    add x0, x0, :lo12:RASPI_AUX_SPI1_CNTL1
    ldr w1, [x0]
    orr w1, w1, #1               // Set enable bit (bit 7)
    str w1, [x0]

    ldp x29, x30, [sp], #16      // Restore frame pointer and link register
    ret

spi_send_byte:



spi_recv_byte:
