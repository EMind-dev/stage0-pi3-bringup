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
 * SPI0 Registers
 * ========================================================================== */
.equ RASPI_AUX_SPI0_CNTL0,   (RASPI_AUX_BASE + 0x80)  // SPI0 Control Register 0 (32-bit)
.equ RASPI_AUX_SPI0_CNTL1,   (RASPI_AUX_BASE + 0x84)  // SPI0 Control Register 1 (8-bit)
.equ RASPI_AUX_SPI0_STAT,    (RASPI_AUX_BASE + 0x88)  // SPI0 Status Register (32-bit)
.equ RASPI_AUX_SPI0_IO,      (RASPI_AUX_BASE + 0x90)  // SPI0 I/O Register (32-bit)
.equ RASPI_AUX_SPI0_PEEK,    (RASPI_AUX_BASE + 0x94)  // SPI0 Peek Register (16-bit)

/* ============================================================================
 * SPI1 Registers
 * ========================================================================== */
.equ RASPI_AUX_SPI1_CNTL0,   (RASPI_AUX_BASE + 0xC0)  // SPI1 Control Register 0 (32-bit)
.equ RASPI_AUX_SPI1_CNTL1,   (RASPI_AUX_BASE + 0xC4)  // SPI1 Control Register 1 (8-bit)
.equ RASPI_AUX_SPI1_STAT,    (RASPI_AUX_BASE + 0xC8)  // SPI1 Status Register (32-bit)
.equ RASPI_AUX_SPI1_IO,      (RASPI_AUX_BASE + 0xD0)  // SPI1 I/O Register (32-bit)
.equ RASPI_AUX_SPI1_PEEK,    (RASPI_AUX_BASE + 0xD4)  // SPI1 Peek Register (16-bit)
