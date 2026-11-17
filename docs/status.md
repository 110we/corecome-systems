# 能力矩阵（只写有代码和验证的）

图例：✅ 已实现且有验证 · 🟡 部分/仅基础 · ❌ 无

| 能力 | bare | COXVBN | OpenKernel |
|---|---|---|---|
| 启动入口 + 链接脚本 | ✅ | ✅ | ✅ |
| 串口输出 | ✅ PL011 | ✅ PL011 | ✅ PL011 |
| arm64 Image 头（QEMU 传 DTB） | ✅ | ✅ | ❌（ELF 启动） |
| FDT/DTB 解析 | ✅ | ✅ | ❌ |
| 物理页分配 | ✅ 128 页池 | ✅ 自检通过 | ❌ |
| MMU / 页表 | ✅ 4K 多级 + 每进程 aspace | 🟡 恒等映射 | ❌ |
| 异常向量 | ✅ | ✅ | ❌ |
| 中断控制器 | ✅ GICv2 | ✅ GICv2 | ❌ |
| 定时器 | ✅ 100Hz | ✅ 就绪（IRQ 屏蔽） | ❌ |
| 调度器 | 🟡 固定片轮转、单核 | ❌ | ❌ |
| 用户态 EL0 | ✅ init + shell | ❌ | ❌ |
| 系统调用 | ✅ 18 号 | ❌ | ❌ |
| fork / COW / clone / 信号 | ✅ | ❌ | ❌ |
| VFS + ramfs | ✅ | ❌ | ❌ |
| ext2（只读） | ✅ | ❌ | ❌ |
| virtio-blk | ✅ | ❌ | ❌ |
| 设备树驱动注册表 | ✅ 分支实现（M5） | ❌ | ❌ |
| 安全组件 | ❌ | 🟡 Key Vault + 模块注册表 | ❌ |
| 网络栈 | ❌ | ❌ | ❌ |

## 验证方式

- **bare**：`make test` 跑 QEMU 并逐项断言（boot / vec / gic / timer / mmu / fault / svc / heap / mm / vfs / sched / EL0 / COW / clone / signal / ext2）。
- **COXVBN**：`make run-coxvbn` 观察串口，应出现 `PHYSICAL ALLOCATOR SELFTEST PASS`、`MMU ENABLED`、`ARM GENERIC TIMER READY`。
- **OpenKernel**：`make run-openkernel` 应出现 `OpenKernel: independent AArch64 kernel entry reached.`

## 已知限制

- 三者都只是单核、无 SMP、无抢占式内核。
- COXVBN 的定时器中断目前屏蔽；OpenKernel 没有异常处理。
- 都不追求 Linux ABI 兼容。
