# UART Driver Documentation

## Overview
This UART driver provides Mini UART functionality for the Raspberry Pi 3 (BCM2837). The Mini UART is part of the AUX peripherals and uses GPIO pins 14 (TX) and 15 (RX).

## Features
- 115200 baud rate, 8N1 configuration (8 data bits, no parity, 1 stop bit)
- Blocking send/receive functions
- String transmission support
- Hexadecimal value output
- Data availability checking

## GPIO Pin Configuration
- **GPIO 14**: UART TX (Transmit) - ALT5 function
- **GPIO 15**: UART RX (Receive) - ALT5 function

## API Functions

### `uart_init`
**Description**: Initializes the Mini UART peripheral
**Parameters**: None
**Returns**: None
**Usage**: Call once during system initialization

### `uart_send_char`
**Description**: Sends a single character
**Parameters**: 
- `w0`: Character to send (8-bit value)
**Returns**: None
**Notes**: Blocks until the character is transmitted

### `uart_recv_char`
**Description**: Receives a single character
**Parameters**: None
**Returns**: 
- `w0`: Received character (8-bit value)
**Notes**: Blocks until a character is received

### `uart_send_string`
**Description**: Sends a null-terminated string
**Parameters**: 
- `x0`: Pointer to null-terminated string
**Returns**: None
**Notes**: Sends characters until null terminator is encountered

### `uart_send_hex`
**Description**: Sends a 64-bit value as hexadecimal string with "0x" prefix
**Parameters**: 
- `x0`: 64-bit value to display as hex
**Returns**: None
**Example**: `uart_send_hex(0x12345678)` outputs "0x0000000012345678"

### `uart_available`
**Description**: Checks if data is available to read
**Parameters**: None
**Returns**: 
- `w0`: 1 if data is available, 0 if not
**Notes**: Non-blocking function for polling

## System Integration

The UART driver is automatically initialized during system boot:

1. **boot.s** - Sets up stack and calls `init_system`
2. **init_system.s** - Clears BSS, calls `uart_init`, then jumps to `_kernel_main`
3. **kernel.s** - Your main kernel code with UART available

## Hardware Configuration

The driver automatically configures:
- GPIO pins 14/15 for UART function (ALT5)
- Baud rate set to 115200
- 8-bit data, no parity, 1 stop bit
- Disables pull-up/pull-down resistors on UART pins
- Enables both transmitter and receiver

## Testing

Connect a USB-to-TTL serial adapter to your Pi:
- **GND** → Pi GND
- **RX** → Pi GPIO 14 (TX)
- **TX** → Pi GPIO 15 (RX)

Use a terminal program (screen, minicom, PuTTY) at 115200 baud to see output.

## Example Usage in Assembly

```assembly
// Send a welcome message
ldr x0, =welcome_msg
bl uart_send_string

// Send current exception level
mrs x0, CurrentEL
bl uart_send_hex

// Check if data is available
bl uart_available
cmp w0, #0
b.eq no_data_available

// Read a character if available
bl uart_recv_char
// Character is now in w0

welcome_msg:
    .asciz "Hello from Pi3!\r\n"
```

## Technical Details

- **System Clock**: Assumes 250MHz system clock for baud rate calculation
- **FIFO**: Uses 8-byte transmit/receive FIFOs
- **Interrupts**: Disabled (polling mode only)
- **Flow Control**: Hardware flow control disabled

## Building

The UART driver is automatically included in the build process. The makefile has been updated to include `drivers/uart.s` in the assembly sources.

```bash
make clean
make
```

This will generate `kernel8.img` ready for deployment to your Raspberry Pi 3.
