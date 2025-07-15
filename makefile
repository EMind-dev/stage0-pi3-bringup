# Toolchain prefix
CROSS_COMPILE = aarch64-elf-

# Files
TARGET = kernel8.img
BUILD_DIR = build
LINKER_SCRIPT = linker.ld
ASM_SRCS = startup/start.s startup/uart_init.s startup/init_system.s
ASM_OBJS = $(patsubst %.s,$(BUILD_DIR)/%.o,$(ASM_SRCS))
C_SRCS = $(wildcard *.c drivers/*.c)
C_OBJS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SRCS))
OBJS = $(ASM_OBJS) $(C_OBJS)

# Commands
AS = $(CROSS_COMPILE)as
CC = $(CROSS_COMPILE)gcc
OBJCOPY = $(CROSS_COMPILE)objcopy
CLEAN = rm -rf

# Flags
ASFLAGS = -mcpu=cortex-a53
CFLAGS = -mcpu=cortex-a53 -ffreestanding -O2 -Wall -Wextra -g -nostdinc -nostdlib 
LDFLAGS = -nostdlib -T $(LINKER_SCRIPT)

# Build rules
.PHONY: all clean flash debug

all: $(BUILD_DIR) $(TARGET)
	@echo "Build completed successfully!"
	@echo "Kernel image: $(TARGET)"

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/startup
	mkdir -p $(BUILD_DIR)/drivers
	@echo "Creating build directory..."
	@echo "Build directory created at $(BUILD_DIR)"
$(BUILD_DIR)/%.o: %.s
	@echo "Assembling $<..."
	$(AS) $(ASFLAGS) -o $@ $<

$(BUILD_DIR)/%.o: %.c
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET): $(OBJS)
	@echo "Linking with debug symbols..."
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(BUILD_DIR)/kernel.elf $^
	$(OBJCOPY) -O binary $(BUILD_DIR)/kernel.elf $@
	@echo "Generated $@"

# Debug target (runs GDB)
debug: $(TARGET)
	aarch64-elf-gdb $(BUILD_DIR)/kernel.elf

# Assumes SD card is mounted at /Volumes/boot - adjust as needed
flash: $(TARGET)
	@echo "Copying $(TARGET) to SD card..."
	@if [ -d "/Volumes/boot" ]; then \
		cp $(TARGET) /Volumes/boot/ && \
		echo "Kernel copied to SD card successfully!"; \
	else \
		echo "Error: /Volumes/boot not found. Is the SD card mounted?"; \
		exit 1; \
	fi

clean:
	@echo "Cleaning build files..."
	$(CLEAN) $(BUILD_DIR) $(TARGET)
	@echo "Clean complete"

run:
	qemu-system-aarch64 -M raspi3b -kernel kernel8.img -serial null -serial stdio