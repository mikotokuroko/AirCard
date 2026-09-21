# AirCard 🎴

[English](README.en.md) | 简体中文

> **适用于 iOS 18 及以上版本的 Apple 钱包卡面与锁屏密码主题自定义工具（无需越狱）**  
> **已在 iOS 27 正式版上测试。**  
> 基于 `airlift` AirTraffic 同步漏洞实现。

<p align="left">
  <a href="https://www.paypal.com/donate/?hosted_button_id=98QRTC2HFRA4Y"><img src="https://img.shields.io/badge/Donate-PayPal-00457C?style=flat-square&logo=paypal" alt="通过 PayPal 捐赠" /></a>
</p>

---

点击顶部的 **中 | EN** 即可切换界面语言，App 会记住你的选择。

## 功能

- 🎨 **自定义卡面：** 为 Apple Pay 和钱包卡片设置自定义图片、纹理或银行标志。
- 🔢 **锁屏密码主题（.passthm）：** 将热门 `.passthm` 主题中的自定义按键图片直接应用到 iOS 18 及以上版本的锁定屏幕。
- 🧩 **主题编辑器：** 使用一张壁纸创建主题（无缝图片切片），或逐个设置按键（单独设置按键）。
- 🔍 **交互式图片取景：** 直接在按键中移动和缩放图片，并通过 iPhone 预览实时查看效果。
- ✏️ **编辑现有 .passthm 主题：** 在主题编辑器中直接打开 Cowabunga 或 Nugget 主题包，修改按键图片、调整图片位置，然后重新导出或应用。
- ⚡ **单张或批量自定义：** 为每张卡片设置独特卡面，或一键将同一设计应用到所有卡片。
- 📱 **轻松检测卡片：** 在 iPhone 的“钱包”App 中轻点任意卡片，即可实时检测其哈希值。
- 🚀 **完全独立运行（通用版）：** 原生支持 **Apple 芯片**和 **Intel（x86）** Mac。所需的设备通信工具和图像处理引擎均已内置于 App 中。
- 📦 **无需额外配置：** macOS 用户无需安装 Homebrew、Python 软件包，也无需配置终端环境。

---

## 安装

### macOS（通用 DMG）

1. 从 [Releases](https://github.com/mak5er/AirCard/releases) 下载 **`AirCard.dmg`**。
2. 打开 `AirCard.dmg`，将 **`AirCard.app`** 拖入**“应用程序”**文件夹。
3. 同时兼容 **Apple 芯片**和 **Intel（x86）** Mac。

> [!NOTE]
> **在 macOS 上首次启动（Gatekeeper）：**
> 如果首次启动时 macOS 提示开发者身份未验证：
> - **方法一（图形界面）：** 在“应用程序”文件夹中右键点击（或按住 Control 键点按）`AirCard.app` ➔ 点击**“打开”** ➔ 再次点击**“打开”**。
> - **方法二（终端）：**
>   ```sh
>   sudo xattr -cr /Applications/AirCard.app
>   ```

---

## 如何自定义 Apple 钱包卡面

1. 使用 USB 线缆将 iPhone 连接到 Mac，确保 iPhone 已解锁，并已信任这台电脑。
2. 在 AirCard 中切换到 **Apple 钱包**标签页，点击**扫描卡片**。
3. 在 iPhone 上：
   - **连按两下侧边（电源）按钮**以打开 Apple Pay。
   - 通过**面容 ID** 验证。
   - **轻点卡片**（或再点一次），即可立即触发检测！
4. 点击任意卡片预览，或将图片直接拖放到卡片上。
5. 点击**应用卡面**。
6. 在 iPhone 上关闭后台钱包App，或重新启动 iPhone，即可查看新的自定义卡面！

---

## 如何应用锁屏密码主题（.passthm）

1. 切换到 AirCard 顶部的**锁屏密码（.passthm）**标签页。
2. 将任意 `.passthm` 文件拖放到 App 中，或点击**选择 .passthm 文件…**。
3. AirCard 会解析主题，并在数字键盘（0–9）上显示交互式预览。
4. 点击**应用锁屏密码主题**。
5. 重新启动 iPhone，以重新载入锁定屏幕缓存，查看自定义锁屏密码按键！

> [!TIP]
> **支持多种语言和粗体文本：**  
> AirCard 会自动为所有系统语言（英语、乌克兰语、俄语、西班牙语、德语、法语等）生成并写入自定义键盘资源，同时生成常规和**粗体文本**的缓存位图（`--white` 和 `--white-bold`），使主题能够适配不同的 iOS 语言和辅助功能显示设置！

---

## 从源码构建

```sh
git clone https://github.com/mak5er/AirCard.git
cd AirCard
chmod +x build.sh
./build.sh
```

这些命令会构建通用二进制文件（`arm64` + `x86_64`），将依赖项打包到 `build/AirCard.app`，并生成 `build/AirCard.dmg`。

---

## 贡献者

- **[@mak5er](https://github.com/mak5er)**（开发者）— [GitHub](https://github.com/mak5er) · [Twitter / X](https://x.com/mak5er)
- **[@Lumid-Off](https://github.com/Lumid-Off)**（贡献者与开发者）— [GitHub](https://github.com/Lumid-Off) · [Twitter / X](https://x.com/LumidOff)
- **[0xjohnny（@0xjohnnydev）](https://github.com/0xjohnnydev)** 开发的 **[AirLift](https://github.com/0xjohnnydev/airlift)**：提供了 `AirliftFFI` 所基于的原始 AirTraffic/ATAirlock 沙盒逃逸方法及概念验证代码。

## 致谢

- 核心漏洞利用基于 `airlift`（AirTraffic 同步沙盒逃逸）。

---

## 支持项目

如果你觉得 AirCard 有帮助，欢迎支持项目的后续开发：

- **PayPal**：[通过 PayPal 捐赠](https://www.paypal.com/donate/?hosted_button_id=98QRTC2HFRA4Y)
- **TON**：`UQBm9KPhtMw-XVVjirUoa09wzrlyWsbeZhKfefl1Uw-qNZ-r`
- **USDT（TRC20）**：`TDkDMCyjYxgvkWUnQiF5Erk2RyPQMT6G1n`
- **USDT / BNB（BEP20）**：`0x0954dc491c502849d04956ef74634aa5931a08e8`
