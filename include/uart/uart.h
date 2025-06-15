/* ============================================================================
 * UART Driver Header for Raspberry Pi 3
 * ==========================================================================*/
#ifndef UART_H
#define UART_H
#include "fw_types.h"
 /* ===========================================================================
 * Function constants for the Mini UART driver
 * ==========================================================================
 * */






#define NO_PRINTABLE_CHAR_LOW_END_ASCII (32U)
#define NO_PRINTABLE_CHAR_HIGH_END_ASCII (126U)
/* ===========================================================================*/
/* Function Prototypes                                                       */
/* ===========================================================================*/ 
 

/* Assembly function declarations (for use in C code) */
extern void uart_init(void);
extern void uart_send_char(u8_t c);
extern u8_t uart_recv_char(void);
extern void uart_send_string(const u8_t* const str);
extern void uart_send_hex(u64_t value);
extern s32_t uart_available(void);

/* ===========================================================================
 * Constants
 * ========================================================================== 
 * */
#define UART_BAUD_RATE      (115200U)
#define UART_DATA_BITS      (8U)
#define UART_STOP_BITS      (1U)
#define UART_PARITY         (0U)       /* No parity */

#endif /* UART_H */
