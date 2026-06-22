# NVIDIA RTX 5060 显卡驱动安装指南 (Arch Linux / CachyOS)

本文档记录了在 **Arch Linux (CachyOS 内核)** 上为 **NVIDIA GeForce RTX 5060** (Blackwell 架构) 安装显卡驱动的完整过程，包括常见问题的排查与解决。

---

## 📌 目录

- [重要前提](#-重要前提)
- [安装步骤](#-安装步骤)
- [常见问题排查](#-常见问题排查)
- [验证安装](#-验证安装)
- [最终已安装的软件包](#-最终已安装的软件包)
- [关键要点总结](#-关键要点总结)
- [后续可选操作](#-后续可选操作)

---

## ⚠️ 重要前提

- **RTX 50 系列 (Blackwell 架构) 必须使用 `nvidia-open` 系列驱动**，传统的闭源驱动 (`nvidia`, `nvidia-dkms`) 不兼容。
- **如果你使用非标准内核 (如 CachyOS, linux-zen 等)，必须使用 `nvidia-open-dkms`**，而非预编译的 `nvidia-open`。
- **强烈建议通过包管理器 (`pacman`) 安装驱动**，不要使用 NVIDIA 官网的 `.run` 文件。

---

## 📦 安装步骤

### 1. 检查当前已安装的 NVIDIA 包

首先，查看系统中已有的 NVIDIA 相关包：

```bash
pacman -Q | grep nvidia
```

---

### 2. 卸载旧版驱动 (如 580xx 系列)

如果存在旧版驱动 (例如 `nvidia-580xx-*`)，全部卸载：

```bash
sudo pacman -Rns nvidia-580xx-dkms nvidia-580xx-utils nvidia-580xx-settings \
    lib32-nvidia-580xx-utils lib32-opencl-nvidia-580xx opencl-nvidia-580xx
```

如果提示依赖冲突，可使用 `-dd` 强制卸载 (谨慎操作)：

```bash
sudo pacman -Rdd <包名>
```

> **注意**：`libva-nvidia-driver` 和 `linux-firmware-nvidia` 是辅助包，与驱动版本无关，**无需卸载**。

---

### 3. 确认当前内核版本

```bash
uname -r
```

根据输出选择对应的驱动包：

| 当前内核 | 需要安装的包 |
| :--- | :--- |
| `linux` (标准 Arch 内核) | `nvidia-open` |
| `linux-lts` | `nvidia-open-lts` |
| `linux-zen` / `linux-cachyos` 等自定义内核 | `nvidia-open-dkms` + 对应内核头文件 |

---

### 4. 安装正确的驱动

以 **CachyOS 内核** 为例：

```bash
# 卸载不匹配的预编译包 (如果之前装了 nvidia-open)
sudo pacman -R nvidia-open

# 安装 CachyOS 内核头文件 (DKMS 编译必需)
sudo pacman -S cachyos-headers

# 安装 DKMS 版驱动及工具
sudo pacman -S nvidia-open-dkms nvidia-utils nvidia-settings lib32-nvidia-utils
```

安装过程中 DKMS 会自动为当前内核编译模块。

---

### 5. 重建 initramfs 并重启

```bash
sudo mkinitcpio -P
sudo reboot
```

> ⚠️ **务必重启**，否则内核中加载的仍是旧模块，会导致 `Driver/library version mismatch` 错误。


## ✅ 验证安装

重启后，依次执行以下命令确认驱动正常工作：

### 1. 检查内核模块

```bash
modinfo nvidia | head -5
```

应显示模块路径和版本信息，而不是 `modinfo: ERROR: Module nvidia not found`。

### 2. 检查 NVIDIA 管理接口

```bash
nvidia-smi
```

正常输出示例：

```
+-----------------------------------------------------------------------------------------+
| NVIDIA-SMI 610.43.02              KMD Version: 610.43.02     CUDA UMD Version: 13.3     |
+-----------------------------------------+------------------------+----------------------+
| GPU  Name                 Persistence-M | Bus-Id          Disp.A | Volatile Uncorr. ECC |
|   0  NVIDIA GeForce RTX 5060        Off |   00000000:01:00.0  On |                  N/A |
+-----------------------------------------+------------------------+----------------------+
```

### 3. 检查 OpenGL 渲染器

```bash
glxinfo | grep "OpenGL renderer"
```

输出应包含 `NVIDIA GeForce RTX 5060`。

### 4. 检查 Vulkan 支持

```bash
vulkaninfo | grep "deviceName"
```

输出应包含 `NVIDIA GeForce RTX 5060`。

---

## 📋 最终已安装的软件包

安装成功后，查询结果如下：

```bash
pacman -Q | grep -E "nvidia|nvml"
```

输出示例：

```
lib32-nvidia-utils 610.43.02-1
libva-nvidia-driver 0.0.17-1.1
linux-firmware-nvidia 1:20260519-1
nvidia-open-dkms 610.43.02-3
nvidia-settings 610.43.02-1
nvidia-utils 610.43.02-3
```

---

## 📌 关键要点总结

| 要点 | 说明 |
| :--- | :--- |
| **驱动系列** | RTX 5060 必须使用 `nvidia-open` (开源内核模块) |
| **内核匹配** | 自定义内核 (CachyOS/zen) 必须使用 `nvidia-open-dkms` |
| **安装方式** | 始终通过 `pacman` 安装，避免手动 `.run` 文件 |
| **重启必要** | 更换驱动后必须重启，否则内核模块版本不匹配 |
| **Secure Boot** | 如启用，需禁用或为模块签名 |
| **双显卡** | Vulkan/OpenGL 可正常识别并切换 (如 Intel + NVIDIA) |

---

## 🚀 后续可选操作

### 启用 NVIDIA 持久化模式

减少驱动加载延迟：

```bash
sudo nvidia-persistenced
```


```bash
sudo pacman -S nvidia-prime
prime-run glxinfo | grep "OpenGL renderer"   # 强制用独显运行
```

### 检查 Wayland 兼容性

```bash
glxinfo | grep "OpenGL renderer"
```

如果桌面环境 (如 KDE Plasma) 已在使用 Wayland，`kwin_wayland` 和 `Xwayland` 会同时运行，无需额外配置。
