# uv 与 Python

个人环境使用 uv 管理 Python 版本、项目虚拟环境和 Python 命令行工具，不把 Homebrew Python 作为项目运行时的固定依赖。

uv 本身通过 Homebrew 安装；数据统一存放到 `~/Toolchains/uv`。

## 1. 目标目录布局

```text
~/Toolchains/uv/
├── bin/          # Python 与 uv tool 的可执行文件
├── cache/        # 可删除并重新生成的缓存
│   └── python/   # Python 下载缓存
├── credentials/  # uv 的凭据存储；不能提交
├── python/       # uv 管理的 Python 安装
└── tools/        # uv tool 的隔离环境
```

项目自己的虚拟环境仍放在项目根目录的 `.venv` 中，不集中放到 `~/Toolchains/uv`。

## 2. 安装 uv

先检查：

```bash
command -v uv
uv --version
```

未安装时运行：

```bash
brew install uv
```

选择 Homebrew 是为了让 uv 本体跟随统一的软件更新流程；不同时使用 uv standalone installer。

## 3. 创建存储目录

```bash
mkdir -p "$HOME/Toolchains/uv/bin"
mkdir -p "$HOME/Toolchains/uv/cache/python"
mkdir -p "$HOME/Toolchains/uv/credentials"
mkdir -p "$HOME/Toolchains/uv/python"
mkdir -p "$HOME/Toolchains/uv/tools"
chmod 700 "$HOME/Toolchains/uv/credentials"
```

## 4. 配置环境变量

当前个人配置使用下面这些变量：

```bash
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

`UV_MANAGED_PYTHON=1` 要求 uv 只使用自己管理的 Python，不回退到 Homebrew Python 或系统 Python。

将它们放入 dotfiles 已创建的 `~/.zshrc.local`。这份文件只保存机器本地配置，不提交到 dotfiles 仓库。

```bash
touch "$HOME/.zshrc.local"
chmod 600 "$HOME/.zshrc.local"
vim "$HOME/.zshrc.local"
```

为当前终端手动载入：

```bash
source "$HOME/.zshrc.local"
```

不要把代理地址、索引令牌或凭据直接写进公开仓库。

## 5. 验证 uv 存储位置

```bash
uv cache dir
uv python dir
uv python dir --bin
uv tool dir
uv tool dir --bin
```

它们应分别落在上面约定的 `~/Toolchains/uv` 子目录中。

uv 官方提醒：缓存与项目虚拟环境最好位于同一个文件系统，否则安装依赖时可能无法使用高效链接。当前布局都位于用户目录，满足这一点。

## 6. 安装 Python

不要无参数安装“当时最新版本”，而是先明确项目所需版本。例如：

```bash
uv python list
uv python install 3.13
```

这里的 `3.13` 只是命令格式示例，不是仓库永久指定的版本。真正安装前应根据项目兼容性确认版本。

检查：

```bash
uv python list --only-installed
python3.13 --version
```

是否使用 `uv python install --default` 创建无版本号的 `python`/`python3` 命令需要单独决定；本项目暂不默认执行，项目中优先使用 `uv run`。

## 7. 立即创建第一个项目

安装完成后，可以直接创建一个不打包发布的普通项目：

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

`3.13` 是示例，真实项目应选择已经确认兼容的 Python 版本。更多项目模板、依赖管理、运行、升级和工具命令见 [uv 项目创建与常用命令](../shared/uv-command-reference.md)。

## 8. 项目工作流

新建项目：

```bash
mkdir -p "$HOME/Codes/example-project"
cd "$HOME/Codes/example-project"
uv init
uv add PACKAGE_NAME
uv run python --version
```

已有项目：

```bash
cd "$HOME/Codes/EXISTING_PROJECT"
uv sync
uv run python --version
```

不要把 `.venv`、uv 缓存和凭据提交到 Git。

## 9. 完成标准

- `uv` 由 Homebrew 提供。
- 五条目录检查命令全部指向 `~/Toolchains/uv`。
- 需要的 Python 版本由 uv 管理。
- 新项目 `.venv/pyvenv.cfg` 中的 `home` 指向 `~/Toolchains/uv/python`。
- 项目依赖通过 `uv sync`/`uv add` 管理，项目命令优先通过 `uv run` 执行。
- 已能在 `~/Codes` 中创建项目并生成 `.venv` 与 `uv.lock`。

返回 [macOS setup 路线](README.md) 查看下一项。

## 参考

- [uv：存储目录](https://docs.astral.sh/uv/reference/storage/)
- [uv：环境变量](https://docs.astral.sh/uv/configuration/environment/)
- [uv：Python 版本](https://docs.astral.sh/uv/concepts/python-versions/)
- [uv：项目工作流](https://docs.astral.sh/uv/guides/projects/)
