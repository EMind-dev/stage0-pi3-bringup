# Toolchain prefix
CROSS_COMPILE = aarch64-elf-

# Files
TARGET = kernel8.img
BUILD_DIR = build
LINKER_SCRIPT = linker.ld
ASM_SRCS = kernel.s boot.s init_system.s
ASM_OBJS = $(patsubst %.s,$(BUILD_DIR)/%.o,$(ASM_SRCS))
C_SRCS = $(wildcard *.c drivers/*.c)
C_OBJS = $(patsubst %.c,$(BUILD_DIR)/%.o,$(C_SRCS))
OBJS = $(ASM_OBJS) $(C_OBJS)

# Commands
AS = $(CROSS_COMPILE)as
CC = $(CROSS_COMPILE)gcc
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
CLEAN = rm -rf

# Flags
ASFLAGS = -mcpu=cortex-a53
CFLAGS = -mcpu=cortex-a53 -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -nostdlib

# Build rules
.PHONY: all clean flash

all: $(BUILD_DIR) $(TARGET)
	@echo "Build completed successfully!"
	@echo "Kernel image: $(TARGET)"

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/drivers

$(BUILD_DIR)/%.o: %.s
	@echo "Assembling $<..."
	$(AS) $(ASFLAGS) -o $@ $<

$(BUILD_DIR)/%.o: %.c
	@echo "Compiling $<..."
	$(CC) $(CFLAGS) -c -o $@ $<

$(TARGET): $(OBJS)
	@echo "Linking..."
	$(LD) $(LDFLAGS) -T $(LINKER_SCRIPT) -o $(BUILD_DIR)/kernel.elf $^
	$(OBJCOPY) -O binary $(BUILD_DIR)/kernel.elf $@
	@echo "Generated $@"

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
