/* ============================================================================
 * UART Driver Header for Raspberry Pi 3
 * 
 * Function prototypes and constants for the Mini UART driver
 * MISRA C compliant interface definitions
 * ========================================================================== */

#ifndef UART_LL_H
#define UART_LL_H

/* MISRA 1.1: Include standard integer types for portability */
#include "types_emind.h"  /* Custom types header for uint8_t, uint16_t, etc. */
/* ============================================================================
 * External Variables - MISRA 8.7: All external variables should be declared
 * ========================================================================== */
extern u8_t __bss_start[];
extern u8_t __bss_end[];
extern u8_t __bss_size[];
/* ============================================================================
 * Function Prototypes - MISRA 8.2 compliant
 * ========================================================================== */

/* Assembly function declarations (for use in C code) */
extern void uart_init(void);
extern void uart_send_char(u8_t c);
extern u8_t uart_recv_char(void);
extern void uart_send_string(const u8_t* str);
extern void uart_send_hex(u32_t value);  /* MISRA 10.1: Explicit unsigned type */
extern int32_t uart_available(void);        /* MISRA 10.1: Explicit signed type */
extern void uart_send(void);

/* ============================================================================
 * Constants - MISRA 2.5: All macros should be used
 * ========================================================================== */
#define UART_BAUD_RATE      115200U  /* MISRA 10.1: Explicit unsigned literal */
#define UART_DATA_BITS      8U       /* MISRA 10.1: Explicit unsigned literal */
#define UART_STOP_BITS      1U       /* MISRA 10.1: Explicit unsigned literal */
#define UART_PARITY         0U       /* No parity - explicit unsigned literal */
#define EXAMPLE_ARRAY_SIZE  32U   /* Size of example array - explicit unsigned literal */
#endif /* UART_H - MISRA 19.15: Header guard completion */
