# C++

这套配置面向 Apple Silicon Mac，使用 Apple Command Line Tools 提供系统 SDK，使用 Homebrew LLVM 作为个人 C++ 项目的编译器与代码分析工具。

## 1. 检查 Apple 基础工具链

```bash
xcode-select -p
xcrun --find clang++
xcrun --find lldb
/usr/bin/clang++ --version
/usr/bin/lldb --version
```

预期 Command Line Tools 位于：

```text
/Library/Developer/CommandLineTools
```

普通命令行 C++ 项目不要求安装完整 Xcode。需要开发 macOS/iOS 图形应用、Metal 或 Xcode 工程时，再单独审阅完整 Xcode。

## 2. 安装 CMake

先确认尚未安装：

```bash
command -v cmake
```

确认后安装并验证：

```bash
brew install cmake
cmake --version
ctest --version
```

## 3. 安装 Ninja

```bash
command -v ninja
brew install ninja
ninja --version
```

Ninja 作为两套模板的 CMake generator，不替换 macOS 自带的 Make。

## 4. 安装 Homebrew LLVM

```bash
brew install llvm
brew --prefix llvm
```

Apple Silicon 的稳定 prefix 预期为：

```text
/opt/homebrew/opt/llvm
```

逐项验证：

```bash
/opt/homebrew/opt/llvm/bin/clang++ --version
/opt/homebrew/opt/llvm/bin/clangd --version
/opt/homebrew/opt/llvm/bin/clang-format --version
/opt/homebrew/opt/llvm/bin/clang-tidy --version
```

Homebrew LLVM 是 keg-only。不要执行 `brew link --force llvm`，也不要修改 `/usr/bin` 或 dotfiles。系统的 Apple Clang、LLDB、SDK 继续保留；需要 Homebrew LLVM 时使用稳定的完整路径：

```bash
/opt/homebrew/opt/llvm/bin/clang++
/opt/homebrew/opt/llvm/bin/clangd
/opt/homebrew/opt/llvm/bin/clang-format
/opt/homebrew/opt/llvm/bin/clang-tidy
```

Homebrew 安装后显示的下面几项不做全局配置：

```text
PATH
LDFLAGS
CPPFLAGS
CMAKE_PREFIX_PATH
```

普通 C++ 项目不需要它们。项目在 `CMakePresets.json` 中显式设置 `CMAKE_CXX_COMPILER=/opt/homebrew/opt/llvm/bin/clang++`；只有开发 LLVM pass、链接 LLVM 库或使用 `find_package(LLVM)` 时，才在对应项目中设置 `CMAKE_PREFIX_PATH`。继续使用 macOS 自带的 libc++ 与 libunwind，不添加 Homebrew caveats 中的替代链接参数。

## 5. 安装 VS Code 扩展

进入后续 [VS Code](vscode.md) 步骤时安装完整扩展基线，其中 C++ 使用：

```text
llvm-vs-code-extensions.vscode-clangd
ms-vscode.cmake-tools
vadimcn.vscode-lldb
```

不同时安装 Microsoft C/C++ 扩展提供另一套 IntelliSense。clangd 读取 CMake 生成的 `compile_commands.json`；CMake Tools 负责配置和构建；CodeLLDB 负责图形化调试。

在 VS Code 本机 User Settings 中指定 Homebrew clangd：

```json
{
  "clangd.path": "/opt/homebrew/opt/llvm/bin/clangd"
}
```

`clangd.path` 是 machine-overridable 设置，不需要写入 dotfiles。不同操作系统可以使用各自的 clangd 路径。

## 6. 项目模板

标准项目与竞赛项目模板独立放在 `~/Codes/cpp-templates`，不放进 `dev-env-setup` 或标准 dotfiles 仓库。

创建标准项目：

```bash
cp -R \
  "$HOME/Codes/cpp-templates/standard" \
  "$HOME/Codes/my-cpp-project"
```

创建一场竞赛的独立目录：

```bash
cp -R \
  "$HOME/Codes/cpp-templates/competitive" \
  "$HOME/Codes/codeforces-round-xxxx"

cd "$HOME/Codes/codeforces-round-xxxx"
```

本机私有的 `~/.zshrc.local` 提供：

```zsh
alias ct='./tools/ct'
```

重新打开终端，或仅为当前终端重新载入：

```bash
source "$HOME/.zshrc.local"
```

之后在竞赛目录根部使用：

```bash
ct new a b c
ct run a
ct test a
ct debug a
```

这项 alias 不进入标准 dotfiles 仓库。模板自身仍可通过 `./tools/ct ...` 使用。

## 7. 完成标准

- CMake、Ninja 和 Homebrew LLVM 的四个主要命令均能正常输出版本。
- `/opt/homebrew/opt/llvm/bin/clang++` 可以完成 C++23 编译与运行。
- clangd、CMake Tools 和 CodeLLDB 已出现在 VS Code 扩展列表中。
- `~/Codes/cpp-templates` 中的标准与竞赛模板均通过实际构建测试。
- `/usr/bin/clang++` 与 Apple Command Line Tools 保持不变。

返回 [macOS setup 路线](README.md) 查看下一项。

## 参考

- [Homebrew LLVM formula](https://formulae.brew.sh/formula/llvm)
- [Homebrew CMake formula](https://formulae.brew.sh/formula/cmake)
- [Homebrew Ninja formula](https://formulae.brew.sh/formula/ninja)
- [clangd VS Code extension](https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd)
- [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)
- [CodeLLDB](https://github.com/vadimcn/codelldb)
