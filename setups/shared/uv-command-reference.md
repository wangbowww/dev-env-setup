# uv 项目创建与常用命令

这份速查表供 macOS 和 Linux 共用。个人默认使用 uv 的 project 工作流：项目依赖写入 `pyproject.toml`，解析结果写入 `uv.lock`，环境位于项目根目录 `.venv`，命令通过 `uv run` 执行。

## 两分钟创建第一个项目

下面创建一个不需要打包发布的普通 Python 项目：

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

执行 `uv sync` 或第一次 `uv run` 后，目录中会出现 `.venv` 和 `uv.lock`。`3.13` 是示例；创建真实项目前，应换成项目实际支持的版本。

需要增加依赖时，先审阅包名和版本要求：

```bash
uv add PACKAGE_NAME
uv tree
```

## 选择项目模板

| 目标 | 命令 | 说明 |
| --- | --- | --- |
| 普通应用 | `uv init APP_NAME` | 默认应用模板，适合 CLI、服务等 |
| 简单脚本项目 | `uv init --no-package PROJECT_NAME` | 不安装项目本身，结构直观 |
| 可发布的库 | `uv init --lib LIBRARY_NAME` | 创建 library 与构建配置 |
| 只要 `pyproject.toml` | `uv init --bare PROJECT_NAME` | 不创建 README、源码目录或 Git 仓库 |
| 初始化当前目录 | `uv init` | 适合已经创建好的空目录 |

显式写出模板参数，比依赖不同 uv 版本的默认模板更清楚。

## Python 版本

| 操作 | 命令 |
| --- | --- |
| 查看可用版本 | `uv python list` |
| 只看 uv 管理的已安装版本 | `uv python list --managed-python --only-installed` |
| 安装一个 minor 的最新 patch | `uv python install 3.13` |
| 同时安装多个版本 | `uv python install 3.12 3.13` |
| 查找匹配的解释器 | `uv python find 3.13` |
| 为当前项目固定版本 | `uv python pin 3.13` |
| 查看 Python 存储目录 | `uv python dir` |
| 卸载 uv 管理的版本 | `uv python uninstall 3.13` |

`uv python pin` 会写入 `.python-version`。这个文件应随项目提交，让其他机器选择相同的 Python 系列。

本 setup 通过 `UV_MANAGED_PYTHON=1` 禁止回退到系统 Python。如果指定版本尚未安装，uv 会安装 managed Python 或报错，而不会悄悄改用系统解释器。项目创建后，`.venv/pyvenv.cfg` 中的 `home` 应指向 `~/Toolchains/uv/python`。

## 项目依赖

| 操作 | 命令 |
| --- | --- |
| 添加运行依赖 | `uv add PACKAGE_NAME` |
| 添加带版本约束的依赖 | `uv add 'PACKAGE_NAME>=1,<2'` |
| 添加开发依赖 | `uv add --dev DEV_PACKAGE_NAME` |
| 删除依赖 | `uv remove PACKAGE_NAME` |
| 查看依赖树 | `uv tree` |
| 同步环境 | `uv sync` |
| 要求 lockfile 不发生变化 | `uv sync --locked` |
| 创建或刷新 lockfile | `uv lock` |
| 升级所有允许升级的依赖 | `uv lock --upgrade` |
| 只升级一个依赖 | `uv lock --upgrade-package PACKAGE_NAME` |

`uv add` 和 `uv remove` 通常会同时更新 `pyproject.toml`、`uv.lock` 与 `.venv`。不要再对同一个 uv 项目使用 `uv pip install` 手工塞入依赖，否则环境状态可能不再由项目文件完整描述。

## 运行项目

```bash
uv run python --version
uv run python path/to/script.py
uv run python -m MODULE_NAME
uv run COMMAND_NAME
uv python find
```

每次 `uv run` 都会先检查 lockfile 和 `.venv` 是否与项目声明一致。项目内的 `uv python find` 通常返回 `.venv` 中的解释器，这是预期结果。通常不需要手动激活虚拟环境。

确实需要传统激活方式时：

```bash
uv sync
source .venv/bin/activate
python --version
deactivate
```

## 拉取已有项目

```bash
git clone REPOSITORY_URL "$HOME/Codes/PROJECT_NAME"
cd "$HOME/Codes/PROJECT_NAME"
uv sync --locked
uv run python --version
```

如果 `uv sync --locked` 报告 lockfile 过期，先查看 `pyproject.toml` 和 `uv.lock` 的差异及仓库说明；不要直接升级所有依赖来绕过错误。

## 兼容传统 requirements 项目

只有当旧仓库没有 uv project 配置、仍以 `requirements.txt` 为真实依赖来源时，才使用低层级的 venv/pip 接口：

```bash
cd "$HOME/Codes/LEGACY_PROJECT"
uv venv --python 3.13
source .venv/bin/activate
uv pip install -r requirements.txt
uv pip list
```

这套命令不会自动把依赖迁移到 `pyproject.toml` 和 `uv.lock`。新项目优先使用前面的 `uv init`、`uv add`、`uv sync` 和 `uv run`。

## 一次性工具与长期工具

运行一次、不写入当前项目：

```bash
uvx TOOL_NAME
```

长期安装一个 Python CLI：

```bash
uv tool install TOOL_NAME
uv tool list
uv tool upgrade TOOL_NAME
uv tool uninstall TOOL_NAME
```

工具同样属于需要审阅的软件。`TOOL_NAME` 只能替换成已经确认来源和用途的包。

## 项目中应提交什么

通常提交：

- `pyproject.toml`
- `uv.lock`
- `.python-version`
- 源码、测试与 README

通常不提交：

- `.venv/`
- uv cache
- uv credentials
- 本机环境变量文件

## 维护与排查

```bash
uv --version
uv help COMMAND
uv cache dir
uv cache prune
uv python dir
uv tool dir
```

macOS 上通过 `brew upgrade uv` 更新 uv 本体；使用 standalone installer 的 Linux 通过 `uv self update` 更新。`uv cache prune` 只清理不再需要的缓存，遇到问题时先查看目录和磁盘占用，不默认运行范围更大的 `uv cache clean`。

## 参考

- [uv：创建项目](https://docs.astral.sh/uv/concepts/projects/init/)
- [uv：项目工作流](https://docs.astral.sh/uv/guides/projects/)
- [uv：安装和管理 Python](https://docs.astral.sh/uv/guides/install-python/)
- [uv：CLI reference](https://docs.astral.sh/uv/reference/cli/)
