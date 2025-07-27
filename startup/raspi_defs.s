/* ============================================================================
 * Raspberry Pi - Auxiliary Peripheral Register Definitions
 * Based on BCM2835 ARM Peripherals Manual
 * Applies to: Mini UART and SPI0/SPI1 grouped under AUX base address
 * ========================================================================== */


/* === Peripheral Base for Raspberry Pi 3 (BCM2837) === */
    .equ PERIPHERAL_BASE,        0x3F000000    // CPU-visible base address (0x7E000000 bus → 0x3F000000 physical)

/* === AUX Base Address (bus: 0x7E215000) === */
    .equ RASPI_AUX_BASE,         (PERIPHERAL_BASE + 0x00215000)

/* ============================================================================
 * AUX Control Registers
 * ========================================================================== */
.equ RASPI_AUX_IRQ,          (RASPI_AUX_BASE + 0x00)  // Auxiliary Interrupt Status (3 bits)
.equ RASPI_AUX_ENABLES,      (RASPI_AUX_BASE + 0x04)  // Auxiliary Enables (bit0=MiniUART, bit1=SPI1, bit2=SPI2)

/* ============================================================================
 * Mini UART Registers (8-bit unless noted)
 * ========================================================================== */
.equ RASPI_AUX_MU_IO,        (RASPI_AUX_BASE + 0x40)  // I/O Data Register
.equ RASPI_AUX_MU_IER,       (RASPI_AUX_BASE + 0x44)  // Interrupt Enable Register
.equ RASPI_AUX_MU_IIR,       (RASPI_AUX_BASE + 0x48)  // Interrupt Identify Register
.equ RASPI_AUX_MU_LCR,       (RASPI_AUX_BASE + 0x4C)  // Line Control Register
.equ RASPI_AUX_MU_MCR,       (RASPI_AUX_BASE + 0x50)  // Modem Control Register
.equ RASPI_AUX_MU_LSR,       (RASPI_AUX_BASE + 0x54)  // Line Status Register
.equ RASPI_AUX_MU_MSR,       (RASPI_AUX_BASE + 0x58)  // Modem Status Register
.equ RASPI_AUX_MU_SCRATCH,   (RASPI_AUX_BASE + 0x5C)  // Scratch Register
.equ RASPI_AUX_MU_CNTL,      (RASPI_AUX_BASE + 0x60)  // Control Register
.equ RASPI_AUX_MU_STAT,      (RASPI_AUX_BASE + 0x64)  // Status Register (32-bit)
.equ RASPI_AUX_MU_BAUD,      (RASPI_AUX_BASE + 0x68)  // Baud Rate Register (16-bit)

/* ============================================================================
 * SPI1 Registers
 * ========================================================================== */
.equ RASPI_AUX_SPI1_CNTL0,   (RASPI_AUX_BASE + 0x80)  // SPI1 (datasheet AUX_SPI0) Control Register 0 (32-bit)
.equ RASPI_AUX_SPI1_CNTL1,   (RASPI_AUX_BASE + 0x84)  // SPI1 (datasheet AUX_SPI0) Control Register 1 (8-bit)
.equ RASPI_AUX_SPI1_STAT,    (RASPI_AUX_BASE + 0x88)  // SPI1 (datasheet AUX_SPI0) Status Register (32-bit)
.equ RASPI_AUX_SPI1_IO,      (RASPI_AUX_BASE + 0x90)  // SPI1 (datasheet AUX_SPI0) I/O Register (32-bit)
.equ RASPI_AUX_SPI1_PEEK,    (RASPI_AUX_BASE + 0x94)  // SPI1 (datasheet AUX_SPI0) Peek Register (16-bit)

/* ============================================================================
 * SPI2 Registers
 * ========================================================================== */
.equ RASPI_AUX_SPI2_CNTL0,   (RASPI_AUX_BASE + 0xC0)  // SPI2 (datasheet: AUX_SPI1) Control Register 0 (32-bit)
.equ RASPI_AUX_SPI2_CNTL1,   (RASPI_AUX_BASE + 0xC4)  // SPI2 (datasheet: AUX_SPI1) Control Register 1 (8-bit)
.equ RASPI_AUX_SPI2_STAT,    (RASPI_AUX_BASE + 0xC8)  // SPI2 (datasheet: AUX_SPI1) Status Register (32-bit)
.equ RASPI_AUX_SPI2_IO,      (RASPI_AUX_BASE + 0xD0)  // SPI2 (datasheet: AUX_SPI1) I/O Register (32-bit)
.equ RASPI_AUX_SPI2_PEEK,    (RASPI_AUX_BASE + 0xD4)  // SPI2 (datasheet: AUX_SPI1) Peek Register (16-bit)

/* ============================================================================
 * PL011 UART Registers
 * ========================================================================== */
.equ RASPI_PL011_UART_BASE,   (PERIPHERAL_BASE + 0x201000)
.equ RASPI_PL011_UART_DR,     (RASPI_PL011_UART_BASE + 0x00)  // Data Register
.equ RASPI_PL011_UART_FR,     (RASPI_PL011_UART_BASE + 0x18)  // Flag Register
.equ RASPI_PL011_UART_IBRD,   (RASPI_PL011_UART_BASE + 0x24)  // Integer Baud Rate Divisor
.equ RASPI_PL011_UART_FBRD,   (RASPI_PL011_UART_BASE + 0x28)  // Fractional Baud Rate Divisor
.equ RASPI_PL011_UART_LCRH,   (RASPI_PL011_UART_BASE + 0x2C)  // Line Control Register
.equ RASPI_PL011_UART_CR,     (RASPI_PL011_UART_BASE + 0x30)  // Control Register
.equ RASPI_PL011_UART_IFLS,   (RASPI_PL011_UART_BASE + 0x34)  // Interrupt FIFO Level Select Register
.equ RASPI_PL011_UART_IMSC,   (RASPI_PL011_UART_BASE + 0x38)  // Interrupt Mask Set/Clear Register
.equ RASPI_PL011_UART_MIS,    (RASPI_PL011_UART_BASE + 0x40)  // Masked Interrupt Status Register
.equ RASPI_PL011_UART_ICR,    (RASPI_PL011_UART_BASE + 0x44)  // Interrupt Clear Register
