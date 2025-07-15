/*
|-----------------------------------------------------------------------------
|               A U T H O R   I D E N T I T Y
|-----------------------------------------------------------------------------
| Initials     Name                      Company
| --------     ---------------------     -------------------------------------
| LL          Lorenzo Lambiase          EmbeddedMind Inc.
|-----------------------------------------------------------------------------
|               R E V I S I O N   H I S T O R Y
|-----------------------------------------------------------------------------
| Date       Ver        Author  Description
| ---------  ---------- ------  ----------------------------------------------
| 2025-07-05 1.0        LL      Initial version
|-----------------------------------------------------------------------------
*/

#ifndef TYPES_EMIND_H
#define TYPES_EMIND_H
/* ============================================================================
 * Custom EmbeddedMind Types Header
 * 
 * This header defines custom types for use in the EmbeddedMind project.
 * It includes standard integer types and custom aliases for consistency.
 * ========================================================================== */

typedef unsigned char      uint8_t;
typedef signed char        int8_t;
typedef unsigned short     uint16_t;
typedef signed short       int16_t;
typedef unsigned long      uint32_t;
typedef signed long        int32_t;
typedef float              float32_t;

/* Custom EmbeddedMind-style aliases for consistency */
typedef uint8_t     u8_t;
typedef int8_t      s8_t;
typedef uint16_t    u16_t;
typedef int16_t     s16_t;
typedef uint32_t    u32_t;
typedef int32_t     s32_t;
typedef float32_t   f32_t;

#endif /* TYPES_EMIND_H */
