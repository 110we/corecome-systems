# COXVBN —— 基础 AArch64 内核
CROSS ?= aarch64-linux-gnu-
CC    := $(CROSS)gcc
BUILD := build

CFLAGS := -std=c11 -O2 -Wall -Wextra -Werror -ffreestanding -fno-builtin \
          -fno-stack-protector -fno-pic -mgeneral-regs-only -mno-outline-atomics -g
INC    := -Iarch/aarch64 -Icore -Imemory -Iplatform -Irecovery -Isecurity

SRCS_C := $(shell find core memory platform recovery security -name '*.c')
SRCS_S := arch/aarch64/boot.S
OBJS   := $(patsubst %.c,$(BUILD)/%.o,$(SRCS_C)) $(patsubst %.S,$(BUILD)/%.o,$(SRCS_S))

.PHONY: all clean run
all: $(BUILD)/coxvbn.elf $(BUILD)/coxvbn.bin

$(BUILD)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INC) -c $< -o $@

$(BUILD)/%.o: %.S
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) $(INC) -c $< -o $@

$(BUILD)/coxvbn.elf: $(OBJS) arch/aarch64/linker.ld
	$(CC) -nostdlib -Wl,-T,arch/aarch64/linker.ld -Wl,--build-id=none $(OBJS) -o $@

$(BUILD)/coxvbn.bin: $(BUILD)/coxvbn.elf
	$(CROSS)objcopy -O binary $< $@

run: $(BUILD)/coxvbn.elf
	qemu-system-aarch64 -M virt,gic-version=2 -cpu cortex-a53 \
	  -display none -monitor none -serial stdio -kernel $(BUILD)/coxvbn.elf

clean:
	rm -rf $(BUILD)
