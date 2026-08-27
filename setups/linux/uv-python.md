# Linux uv 与 Python

Linux 继续使用和 macOS 相同的 `~/Toolchains/uv` 数据布局。区别是 uv 本体使用 Astral 官方 standalone installer，而不是为 Linux 额外安装 Homebrew。

## 1. 创建目录并配置当前终端

```bash
mkdir -p "$HOME/Toolchains/uv/bin"
mkdir -p "$HOME/Toolchains/uv/cache/python"
mkdir -p "$HOME/Toolchains/uv/credentials"
mkdir -p "$HOME/Toolchains/uv/python"
mkdir -p "$HOME/Toolchains/uv/tools"
chmod 700 "$HOME/Toolchains/uv/credentials"

export UV_INSTALL_DIR="$HOME/Toolchains/uv/bin"
export UV_CACHE_DIR="$HOME/Toolchains/uv/cache"
export UV_PYTHON_CACHE_DIR="$HOME/Toolchains/uv/cache/python"
export UV_CREDENTIALS_DIR="$HOME/Toolchains/uv/credentials"
export UV_PYTHON_INSTALL_DIR="$HOME/Toolchains/uv/python"
export UV_PYTHON_BIN_DIR="$HOME/Toolchains/uv/bin"
export UV_TOOL_DIR="$HOME/Toolchains/uv/tools"
export UV_TOOL_BIN_DIR="$HOME/Toolchains/uv/bin"
export UV_MANAGED_PYTHON=1
export UV_NO_MODIFY_PATH=1
export PATH="$HOME/Toolchains/uv/bin:$PATH"
```

`UV_MANAGED_PYTHON=1` 要求 uv 只使用自己管理的 Python，不回退到发行版自带的 Python。

把同一组 `export` 保存到 dotfiles 已创建的 `~/.zshrc.local`：

```bash
touch "$HOME/.zshrc.local"
chmod 600 "$HOME/.zshrc.local"
vim "$HOME/.zshrc.local"
```

当前 Shell 可以手动运行 `source "$HOME/.zshrc.local"` 立即加载；后续新开的 Zsh 会自动加载这组配置。

## 2. 审阅并安装 uv

先阅读官方安装脚本：

```bash
curl -LsSf https://astral.sh/uv/install.sh | less
```

确认后安装到自定义目录，并禁止安装器修改 Shell 配置：

```bash
curl -LsSf https://astral.sh/uv/install.sh | \
  env UV_INSTALL_DIR="$HOME/Toolchains/uv/bin" UV_NO_MODIFY_PATH=1 sh
```

验证：

```bash
command -v uv
uv --version
uv cache dir
uv python dir
uv python dir --bin
uv tool dir
uv tool dir --bin
```

## 3. 安装明确版本的 Python

先查看可用版本，再按项目兼容性选择：

```bash
uv python list
uv python install 3.13
uv python list --only-installed
```

`3.13` 只是命令示例，不是永久固定版本。本项目暂不默认执行 `uv python install --default`，项目命令优先使用 `uv run`。

standalone installer 安装的 uv 使用下面的命令更新：

```bash
uv self update
```

## 4. 立即创建第一个项目

```bash
cd "$HOME/Codes"
uv init --no-package hello-uv
cd hello-uv
uv python pin 3.13
uv sync
uv run python --version
grep '^home = ' .venv/pyvenv.cfg
uv run main.py
```

`3.13` 是示例，真实项目应选择已经确认兼容的 Python 版本。完整命令速查见 [uv 项目创建与常用命令](../shared/uv-command-reference.md)。

## 完成标准

- uv 位于 `~/Toolchains/uv/bin`。
- 所有 uv 数据目录都落在 `~/Toolchains/uv`。
- Python 版本由项目兼容性明确决定。
- 新项目 `.venv/pyvenv.cfg` 中的 `home` 指向 `~/Toolchains/uv/python`。
- 已能在 `~/Codes` 中创建项目并生成 `.venv` 与 `uv.lock`。

桌面 Linux 返回 [Linux setup 路线](README.md) 继续安装 Visual Studio Code。无桌面服务器可以在这里停止宿主机基础路线。

## 参考

- [uv 官方安装方法](https://docs.astral.sh/uv/getting-started/installation/)
- [uv installer 自定义选项](https://docs.astral.sh/uv/reference/installer/)
- [uv 存储目录](https://docs.astral.sh/uv/reference/storage/)
