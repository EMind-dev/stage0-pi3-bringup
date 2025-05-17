# Toolchain prefix
CROSS_COMPILE = aarch64-elf-

# Files
TARGET = kernel8.img
BUILD_DIR = build
LINKER_SCRIPT = linker.ld
SRC = kernel.S
OBJ = $(BUILD_DIR)/kernel.o

# Commands
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
OBJCOPY = $(CROSS_COMPILE)objcopy
CLEAN = rm -rf

# Build rules
all: $(BUILD_DIR) $(TARGET)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(OBJ): $(SRC)
	$(AS) -o $@ $<

$(TARGET): $(OBJ)
	$(LD) -T $(LINKER_SCRIPT) -o $(BUILD_DIR)/kernel.elf $<
	$(OBJCOPY) -O binary $(BUILD_DIR)/kernel.elf $@

clean:
	$(CLEAN) $(BUILD_DIR) $(TARGET)
