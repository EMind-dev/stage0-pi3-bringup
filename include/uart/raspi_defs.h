/**
 * REG32: reads/writes a 32-bit MMIO register.
 * @param addr Physical address of the register.
 * @note volatile to prevent compiler optimizations.
 * @MISRA-C-2012 Rule 10.1 deviation: pointer-integer conversion necessary
 */
#define REG32(addr) (*(volatile uint32_t *)(addr))

/**
 * REG16: reads/writes a 16-bit MMIO register.
 * @param addr Physical address of the register.
 * @note volatile to prevent compiler optimizations.
 * @MISRA-C-2012 Rule 10.1 deviation: pointer-integer conversion necessary
 */
#define REG16(addr) (*(volatile uint16_t *)(addr))
/**
 * REG8: reads/writes an 8-bit MMIO register.
 * @param addr Physical address of the register.
 * @note volatile to prevent compiler optimizations.
 * @MISRA-C-2012 Rule 10.1 deviation: pointer-integer conversion necessary
 */
#define REG8(addr) (*(volatile uint8_t *)(addr))

/* DEFINE REGx_SET macro for clarity, its generally better use this one in the code to improve clarity */
/**
 * REG32_SET: sets a 32-bit MMIO register to a value.
 * @param addr Physical address of the register.
 * @param value Value to set.
 * @note volatile to prevent compiler optimizations.
 * @MISRA-C-2012 Rule 10.1 deviation: pointer-integer conversion necessary
 */
#define REG32_SET(addr, value) (REG32(addr) = (value))
/**
 * REG16_SET: sets a 16-bit MMIO register to a value.
 * @param addr Physical address of the register.
 * @param value Value to set.
 * @note volatile to prevent compiler optimizations.
 * @MISRA-C-2012 Rule 10.1 deviation: pointer-integer conversion necessary
 */
#define REG16_SET(addr, value) (REG16(addr) = (value))
/**
 * REG8_SET: sets an 8-bit MMIO register to a value.
 * @param addr Physical address of the register.
 * @param value Value to set.
 * @note volatile to prevent compiler optimizations.
 * @MISRA-C-2012 Rule 10.1 deviation: pointer-integer conversion necessary
 */
#define REG8_SET(addr, value) (REG8(addr) = (value))

/* DEFINE REGx_GET macro for clarity, its generally better use this one in the code to improve clarity */

#define REG32_GET(addr) (REG32(addr))  /**< Get a 32-bit MMIO register value */
#define REG16_GET(addr) (REG16(addr))  /**< Get a 16-bit MMIO register value */
#define REG8_GET(addr) (REG8(addr))    /**< Get an 8-bit MMIO register value */