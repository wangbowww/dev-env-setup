# macOS 基础准备与目录约定

本页完成三件事：确认机器架构与系统版本、准备 Apple Command Line Tools，以及创建个人代码和工具链目录。

## 1. 检查系统

```bash
sw_vers
uname -m
```

Apple Silicon 应显示 `arm64`。这个结果会影响 Homebrew 的默认安装路径。

当前个人环境基线是 Apple Silicon；本文档不假定 Intel Mac 与它使用相同路径。

## 2. 检查 Command Line Tools

```bash
xcode-select -p
```

如果输出类似下面的路径，说明已经安装：

```text
/Library/Developer/CommandLineTools
```

如果命令报错，再运行：

```bash
xcode-select --install
```

按照 macOS 弹窗完成安装，然后重新运行 `xcode-select -p`。

这里安装的是 Command Line Tools，不是完整 Xcode。除非以后确实需要 Apple 平台开发，否则本项目不默认安装完整 Xcode。

## 3. 创建个人目录

约定所有项目代码放在 `~/Codes`，个人管理的工具链数据放在 `~/Toolchains`：

```bash
mkdir -p "$HOME/Codes"
mkdir -p "$HOME/Toolchains"
```

检查结果：

```bash
ls -ld "$HOME/Codes" "$HOME/Toolchains"
```

不要在这里预先创建每一种语言的目录。Python 使用的 uv 子目录会在对应文档中创建；C/C++ 等工具链以后确认需求后再添加。

## 4. 完成标准

- `uname -m` 的输出已经确认。
- `xcode-select -p` 能返回有效目录。
- `~/Codes` 与 `~/Toolchains` 已存在。

返回 [macOS setup 路线](README.md) 查看下一项。

## 参考

- [Homebrew 的 macOS 安装要求](https://docs.brew.sh/Installation#macos-requirements)
