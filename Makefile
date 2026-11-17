# 三套 AArch64 教学系统的统一入口。
# 每个内核各自可独立构建：make <name>；跑 QEMU：make run-<name>。
CROSS ?= aarch64-linux-gnu-
QEMU  ?= qemu-system-aarch64
QEMUFLAGS := -M virt,gic-version=2 -cpu cortex-a53 -display none -monitor none

.PHONY: all bare coxvbn openkernel clean test run-bare run-coxvbn run-openkernel

all: bare coxvbn openkernel

bare:
	$(MAKE) -C kernels/bare/kernel

coxvbn:
	$(MAKE) -C kernels/coxvbn

openkernel:
	$(MAKE) -C kernels/openkernel

# bare 有完整的 M0–M4 断言（需要 qemu + 可选 e2fsprogs）
test: bare
	$(MAKE) -C kernels/bare/kernel test

run-bare: bare
	$(QEMU) $(QEMUFLAGS) -serial stdio -kernel kernels/bare/kernel/build/kernel.bin

run-coxvbn: coxvbn
	$(QEMU) $(QEMUFLAGS) -serial stdio -kernel kernels/coxvbn/build/coxvbn.bin

run-openkernel: openkernel
	$(QEMU) $(QEMUFLAGS) -serial stdio -kernel kernels/openkernel/build/openkernel.elf

clean:
	$(MAKE) -C kernels/bare/kernel clean
	$(MAKE) -C kernels/coxvbn clean
	$(MAKE) -C kernels/openkernel clean
