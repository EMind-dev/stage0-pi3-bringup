/* ============================================================================
 * UART Driver Header for Raspberry Pi 3
 * 
 * Function prototypes and constants for the Mini UART driver
 * MISRA C compliant interface definitions
 * ========================================================================== */

#ifndef UART_H
#define UART_H

/* MISRA 1.1: Include standard integer types for portability */
#include <stdint.h>

/* ============================================================================
 * Function Prototypes - MISRA 8.2 compliant
 * ========================================================================== */

/* Assembly function declarations (for use in C code) */
extern void uart_init(void);
extern void uart_send_char(char c);
extern char uart_recv_char(void);
extern void uart_send_string(const char* str);
extern void uart_send_hex(uint64_t value);  /* MISRA 10.1: Explicit unsigned type */
extern int32_t uart_available(void);        /* MISRA 10.1: Explicit signed type */

/* ============================================================================
 * Constants - MISRA 2.5: All macros should be used
 * ========================================================================== */
#define UART_BAUD_RATE      115200U  /* MISRA 10.1: Explicit unsigned literal */
#define UART_DATA_BITS      8U       /* MISRA 10.1: Explicit unsigned literal */
#define UART_STOP_BITS      1U       /* MISRA 10.1: Explicit unsigned literal */
#define UART_PARITY         0U       /* No parity - explicit unsigned literal */

#endif /* UART_H - MISRA 19.15: Header guard completion */
