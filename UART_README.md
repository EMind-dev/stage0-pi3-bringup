# UART README

## What Was Implemented

### 1. UART Driver (`drivers/uart.s`)
A complete Mini UART driver for Raspberry Pi 3 with the following features:
- **Initialization**: Full GPIO and UART peripheral setup
- **Character I/O**: Send/receive single characters
- **String Output**: Send null-terminated strings
- **Hex Output**: Display 64-bit values in hexadecimal format
- **Data Polling**: Check if received data is available

### 2. System Integration
- **Updated `init_system.s`**: Added UART initialization before kernel main
- **Updated `kernel.s`**: Added demonstration code showing UART output
- **Updated `makefile`**: Included UART driver in build process

### 3. Hardware Configuration
The UART driver configures:
- **GPIO 14**: TX (Transmit) - ALT5 function
- **GPIO 15**: RX (Receive) - ALT5 function  
- **Baud Rate**: 115200 bps
- **Data Format**: 8N1 (8 data bits, no parity, 1 stop bit)
- **Pull Resistors**: Disabled on UART pins

### 4. API Functions Available

#### Assembly Functions:
```assembly
uart_init           // Initialize UART system
uart_send_char      // Send single character (w0 = char)
uart_recv_char      // Receive single character (returns in w0)
uart_send_string    // Send null-terminated string (x0 = string ptr)
uart_send_hex       // Send 64-bit hex value (x0 = value)
uart_available      // Check if data available (returns 1/0 in w0)
```

#### C Function Prototypes (in `include/uart.h`):
```c
void uart_init(void);
void uart_send_char(char c);
char uart_recv_char(void);
void uart_send_string(const char* str);
void uart_send_hex(unsigned long value);
int uart_available(void);
```

## Boot Sequence

1. **`boot.s`**: Sets up stack pointer and calls `init_system`
2. **`init_system.s`**: 
   - Clears BSS section
   - Calls `uart_init` to initialize UART
   - Jumps to `_kernel_main`
3. **`kernel.s`**: 
   - Sends welcome message via UART
   - Displays current exception level
   - Enters infinite wait loop

## Expected Output

When you boot this kernel, you should see:
```
Pi3 Stage0 Bootloader - UART Initialized
Current Exception Level: 0x0000000000000001
System initialization complete. Entering wait loop.
```

## Testing Setup

### Hardware Connection:
Connect a USB-to-TTL serial adapter:
- **GND** → Pi Ground
- **RX** → Pi GPIO 14 (TX)  
- **TX** → Pi GPIO 15 (RX)

### Software:
Use any terminal program at **115200 baud, 8N1**:
- macOS: `screen /dev/tty.usbserial-XXXX 115200`
- Linux: `minicom -D /dev/ttyUSB0 -b 115200`
- Windows: PuTTY or TeraTerm

## File Structure
```
stage0-pi3-bringup/
├── boot.s                              // Legacy boot entry point
├── init_system.s                       // Legacy system initialization
├── kernel.s                            // Legacy main kernel
├── kernel8.img                         // Final bootable image
├── LICENSE                             // Project license
├── linker.ld                          // Linker script for memory layout
├── makefile                           // Build configuration
├── README.md                          // Project documentation
├── UART_README.md                     // UART implementation details
├── stage0-pi3-bringup.code-workspace // VS Code workspace
├── build/                             // Build output directory
│   ├── kernel.elf                     // ELF executable with debug symbols
│   ├── drivers/
│   │   ├── main.o                     // Compiled main C object
│   │   └── uart_LL.o                  // Compiled UART low-level object
│   └── startup/
│       ├── init_system.o              // Compiled system initialization
│       ├── start.o                    // Compiled boot entry point
│       └── uart_init.o                // Compiled UART initialization
├── drivers/                           // Driver implementations
│   ├── main.c                         // Main C application
│   └── uart_LL.c                      // UART low-level C implementation
├── include/                           // Header files
│   ├── gpio.h                         // GPIO register definitions
│   ├── types_emind.h                  // Custom type definitions
│   └── uart_LL.h                      // UART function prototypes
├── startup/                           // Boot and initialization code
│   ├── init_system.s                  // System initialization assembly
│   ├── raspi_defs.s                   // Raspberry Pi hardware definitions
│   ├── start.s                        // Boot entry point assembly
│   └── uart_init.s                    // UART initialization assembly
└── utils/                             // Utility scripts
    └── update_headers.sh              // Header update script
```

## QEMU Installation Guide

### macOS Installation

#### Using Homebrew (Recommended)
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install QEMU
brew install qemu

# Verify installation
qemu-system-aarch64 --version
```

#### Using MacPorts
```bash
# Install MacPorts if not already installed
# Download from: https://www.macports.org/install.php

# Install QEMU
sudo port install qemu

# Verify installation
qemu-system-aarch64 --version
```

### Linux Installation

#### Ubuntu/Debian
```bash
# Update package list
sudo apt update

# Install QEMU
sudo apt install qemu-system-arm qemu-system-aarch64

# Verify installation
qemu-system-aarch64 --version
```

#### CentOS/RHEL/Fedora
```bash
# For CentOS/RHEL
sudo yum install qemu-system-aarch64

# For Fedora
sudo dnf install qemu-system-aarch64

# Verify installation
qemu-system-aarch64 --version
```

#### Arch Linux
```bash
# Install QEMU
sudo pacman -S qemu-system-aarch64

# Verify installation
qemu-system-aarch64 --version
```

### Building from Source (Advanced)
If you need the latest features or your distribution doesn't have a recent version:

```bash
# Download QEMU source
wget https://download.qemu.org/qemu-8.1.0.tar.xz
tar xvf qemu-8.1.0.tar.xz
cd qemu-8.1.0

# Configure build (minimal for ARM64 support)
./configure --target-list=aarch64-softmmu --enable-debug

# Build and install
make -j$(nproc)
sudo make install
```

## Build Process
```bash
make clean  # Clean previous builds
make all    # Build kernel8.img
make run    # Launch qemu
```

## Next Steps

You can now:
1. **Flash `kernel8.img`** to SD card and boot your Pi 3
2. **Extend the driver** with interrupt support or DMA
3. **Add more peripherals** (SPI, I2C, GPIO) using similar patterns
4. **Implement a shell** or command interpreter over UART
5. **Add debugging utilities** using the UART output functions

The UART driver provides a solid foundation for early-stage debugging and communication in your Raspberry Pi 3 bootloader!
