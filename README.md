# Raspberry Pi 3 Stage 0 Bootloader

This project implements a second- and third-stage bootloader for the Raspberry Pi 3 (Broadcom BCM2837 SoC), developed as an EmbeddedMind showcase. It demonstrates advanced SoC bring‑up techniques and bare‑metal firmware development, with a focus on early ARMv8 core configuration, BSS section initialization, and Mini UART‑based debugging.

## Table of Contents
- [Key Features](#key-features)
- [Project Architecture](#project-architecture)
- [File Layout](#file-layout)
- [Prerequisites](#prerequisites)
- [Build Instructions](#build-instructions)
- [Usage](#usage)
- [Customization](#customization)
- [License](#license)

## Key Features

- **ARMv8 Core Setup**: Establishes the initial stack pointer and transitions the CPU into the correct execution state (EL1) using AArch64 assembly.
- **BSS Section Clearing**: Zeroes out the BSS memory region during early bring‑up to ensure a deterministic runtime environment.
- **Mini UART Driver**: Implements a minimalist assembly driver for the Pi 3’s Mini UART, providing routines for character, string, and hexadecimal-value transmission.
- **Debug Messaging**: Outputs concise status and exception‑level information via UART to facilitate real‑time system inspection.
- **C Interface**: Illustrates integration with MISRA‑compliant C code, demonstrating how to invoke UART services from higher‑level application modules.
- **MMIO Access Macros**: Provides centralized macros (REG32, REG16, REG8) in raspi_defs.h to enable safe, documented memory-mapped register access in C and prevent manual pointer conversion errors.
## Project Architecture

1. **boot.s**: Defines the entry point (`_start`), sets up the stack pointer, and branches to the system initialization routine.
2. **init_system.s**: Conducts early platform setup, including BSS clearing and UART initialization, before handing control to the kernel.
3. **kernel.s**: Implements `_kernel_main`, which emits welcome messages, displays system parameters, and enters a perpetual idle loop.
4. **uart/***: Contains:
   - `raspi_defs.s`: SoC register definitions for AUX and GPIO modules.
   - `uart.s`: Core Mini UART routines for TX/RX operations.
   - `uart.h`: Public UART API declarations.
   - `uart.c`: Demonstrates interactive echo mode, non‑printable character handling, and higher‑level UART utilities.
5. **include/fw_types.h**: Defines essential data types (`u8_t`, `u32_t`, `bool_t`, etc.) in alignment with MISRA guidelines.

## File Layout

```
/boot.s
/init_system.s
/kernel.s
/uart/
    raspi_defs.s
    uart.s
    uart.h
    uart.c
/include/
    fw_types.h
```

## Prerequisites

- Raspberry Pi 3 (BCM2837 SoC)
- ARMv8 bare‑metal toolchain (e.g., `aarch64-none-elf-gcc`)
- GNU Make

## Build Instructions

```sh
# Clone the repository
git clone https://github.com/your-username/pi3-stage0-bootloader.git
cd pi3-stage0-bootloader

# Build the kernel image
make all

# Deploy the kernel to SD card
cp kernel8.img /media/pi/boot/
```

## Usage

1. Insert the SD card into the Raspberry Pi 3 and power on.
2. Connect a TTL serial adapter to the GPIO UART pins (115200 baud).
3. Observe the bootloader’s debug output in your serial terminal.

## TODO

- **Peripheral Support**: Extend `init_system.s` with additional peripheral driver implementations.
- **Advanced Stages**: Integrate file‑system loaders or more sophisticated kernel payloads.

## License

This project is distributed under the MIT License. See the `LICENSE` file for details.

---

*EmbeddedMind Showcase – elegant and precise SoC bring‑up demonstrations.*