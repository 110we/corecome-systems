# corecome-systems · 三套 AArch64 教学系统

同一仓库里维护三个**互相独立**的内核，每个都能单独构建、单独在 QEMU `virt` 上启动。
它们共享“教学内核”的定位，但**不共享代码**：各自有启动入口、链接脚本、构建目标。

| 系统 | 内核能力 | 当前状态 |
|---|---|---|
| **bare** | 宏内核：EL0/EL1、4K 页表、COW fork、clone 线程、信号、ramfs、只读 ext2、virtio-blk、FDT 解析、EL0 init + shell | **可完整跑通** M0–M4，`make test` 有断言 |
| **COXVBN** | 基础内核：FDT 解析、物理页分配器、初始 MMU（恒等映射）、GICv2、ARM 通用定时器、异常向量、Key Vault、模块注册表、紧急恢复 | **可启动到内存/MMU/定时器就绪**，无用户态、无调度、无文件系统 |
| **OpenKernel** | 独立内核：自建启动入口、串口控制台 | **仅引导 + 串口输出**，调度/MMU/驱动/用户 ABI 均未实现 |

> 这不是三套完整操作系统。完整 OS 需要用户态、系统调用、文件系统、设备模型、网络栈，
> 目前只有 **bare** 具备其中的一部分；COXVBN 与 OpenKernel 是引导期的基础件。
> 每个内核目录里的 README 写明了已实现与未实现，不把计划当能力。

## 需要

- `aarch64-linux-gnu-gcc`（交叉编译）
- `qemu-system-aarch64`（运行）
- `e2fsprogs`（可选，bare 的 ext2 断言需要）
- `make`

Ubuntu 上装：

```bash
sudo apt-get install -y gcc-aarch64-linux-gnu qemu-system-arm e2fsprogs
```

## 构建

```bash
make            # 三个都编
make bare       # 只编 bare
make coxvbn     # 只编 COXVBN
make openkernel # 只编 OpenKernel
```

产物：

```
kernels/bare/kernel/build/kernel.bin     （arm64 Image，可直接 -kernel）
kernels/coxvbn/build/coxvbn.bin          （arm64 Image）
kernels/openkernel/build/openkernel.elf  （ELF）
```

## 运行

```bash
make run-bare
make run-coxvbn
make run-openkernel
```

或者手动：

```bash
qemu-system-aarch64 -M virt,gic-version=2 -cpu cortex-a53 \
  -display none -monitor none -serial stdio \
  -kernel kernels/coxvbn/build/coxvbn.bin
```

`Ctrl-A X` 退出 QEMU。

## 自检

```bash
make test       # 只有 bare 有完整断言（含 EL0 init → shell → ls/cat）
```

COXVBN 与 OpenKernel 目前只验证“能启动并打印预期标记”，见 `.github/workflows/build.yml`。

## 目录

```
kernels/bare/        宏内核 + drivers/ + filesystems/ + userspace/runtime + tests/qemu
kernels/coxvbn/      基础内核（arch / core / memory / platform / security / recovery）
kernels/openkernel/  最小内核（arch / core / platform）
docs/                能力矩阵与构建细节
```

## 许可证

AGPL-3.0，见 `LICENSE`。
