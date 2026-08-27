# Linux 容器 setup 路线

这是一条独立于 macOS 和 Linux 宿主机的开发环境路线。仓库只提供 Linux-based 容器；容器创建完成时已经包含可复用的 Linux setup，不需要再进入容器重走 Linux 宿主机文档。

## 适用范围

- C/C++：Debian 12，支持 `amd64` 与 `arm64`。
- Go：Debian 12 + Go 1.26，支持 `amd64` 与 `arm64`。
- PyTorch：Ubuntu 22.04 + PyTorch 2.8 + CUDA 12.8，仅适合 `linux/amd64` NVIDIA 主机。

macOS 可以运行 C/C++ 和 Go Linux 容器。PyTorch CUDA 容器不是 Apple Silicon 的本地 PyTorch 路线，也不能使用 Mac GPU。

## 1. 准备宿主机

宿主机只负责运行和连接容器，需要提前具备：

- Git，以及已经完成的 GitHub SSH 认证。
- 正在运行的 `ssh-agent`，其中已载入 `~/.ssh/github-key`。
- `~/.ssh/github-key.pub`，devcontainer 只读挂载这份公钥，不挂载私钥。
- Visual Studio Code、Dev Containers 扩展和一个 Docker-compatible 容器运行时。

容器运行时的具体选择与安装尚未在本仓库定稿；在 macOS 上不能把 Docker Desktop、Colima 等方案未经审阅地互换。

## 2. 选择环境

| 环境 | 打开的目录 | 官方基础镜像 |
| --- | --- | --- |
| C/C++ | `containers/cpp` | `mcr.microsoft.com/devcontainers/cpp:bookworm` |
| Go | `containers/go` | `mcr.microsoft.com/devcontainers/go:1.26-bookworm` |
| PyTorch GPU | `containers/pytorch` | `pytorch/pytorch:2.8.0-cuda12.8-cudnn9-runtime` |

## 3. 创建容器

在 VS Code 中打开所选目录，然后运行：

```text
Dev Containers: Reopen in Container
```

devcontainer 会从同目录的 Dockerfile 本地构建镜像，而不是拉取个人账号下的预构建镜像。首次构建需要下载基础镜像、uv、Python 和 dotfiles 依赖，耗时会明显长于以后重建。

如果需要从命令行只验证镜像构建，应在仓库根目录执行其中一条：

```bash
docker build -f containers/cpp/Dockerfile .
docker build -f containers/go/Dockerfile .
docker build -f containers/pytorch/Dockerfile .
```

PyTorch 容器还要求宿主机已正确安装 NVIDIA 驱动、NVIDIA Container Toolkit，并能够执行带 `--gpus all` 的容器。

## 4. 运行环境检查

每个镜像都内置同一个 `check-env` 命令，并通过 `PERSONAL_DEV_PROFILE` 自动选择 C/C++、Go 或 PyTorch 检查项。容器创建完成后执行：

```bash
check-env
```

脚本会检查：

- Linux、Git、SSH client、Zsh、Vim 和 dotfiles。
- `/root/Codes`、uv 自定义目录、环境变量和 uv-managed Python。
- 当前 profile 的编译器、Go 工具链或 PyTorch/CUDA build。
- Git 身份、SSH agent、signing 公钥等宿主机接入状态。
- VS Code 连接建立后，当前语言真正需要的扩展。

`FAIL` 表示镜像内部缺少必需环境，脚本会返回非零状态；`WARN` 表示镜像已经可用，但宿主机账号、SSH agent、VS Code 连接或 NVIDIA GPU 尚未接入。修复 `FAIL` 后应重新构建镜像，不要在运行中的容器里手工补安装。

C/C++ 和 Go 容器不安装 Python、Pylance 或 Jupyter 扩展。宿主机上的 Remote SSH、Dev Containers、语言包等 UI/连接扩展继续由宿主机的扩展基线负责。三个容器只共享 GitHub Actions、ChatGPT 和 PDF 扩展，再分别添加：

| 容器 | 语言扩展 |
| --- | --- |
| C/C++ | `ms-vscode.cpptools` |
| Go | `golang.Go` |
| PyTorch | Python、Pylance、debugpy、Python Environments、Jupyter、Jupyter Keymap |

此时可以直接使用 [uv 项目创建与常用命令](../shared/uv-command-reference.md) 在 `/root/Codes` 中创建或恢复 Python 项目。

## 5. 接入个人身份，而不是重新 setup

镜像不能包含私钥、个人 Git 身份或 VS Code 登录状态。Dev Containers 会在启动时复用宿主机 Git 配置并转发正在运行的 SSH agent；配置还会把只读公钥挂载到容器内 `/root/.ssh/github-key.pub`，供 SSH 提交签名调用 agent 中的私钥。

进入容器后只做验证：

```bash
git config --global --get user.name
git config --global --get user.email
git config --global --get gpg.format
git config --global --get user.signingkey
ssh-add -l
ssh -T git@github.com
```

`user.signingkey` 应为 `/root/.ssh/github-key.pub`。如果宿主机没有完成 Git 身份、GitHub SSH 和 signing 配置，应回到对应宿主机路线完成；不要把这些值或私钥写入 Dockerfile。

VS Code User Settings 继续通过账户同步。devcontainer 配置只负责安装已确认的扩展列表，不把账户同步数据烘进镜像。

## 容器内已经完成的 Linux setup

| Linux setup 内容 | 容器行为 |
| --- | --- |
| `~/Codes`、`~/Toolchains` | 构建时创建；workspace 挂载到 `/root/Codes` |
| APT 基础工具、Git、SSH client、Zsh、Vim | 构建时安装 |
| dotfiles | 按固定 Git commit 构建进镜像 |
| Git 身份、SSH 私钥、GitHub signing | 复用宿主机配置、agent 和只读公钥，不写入镜像 |
| uv 自定义目录 | 固定在 `/root/Toolchains/uv` |
| Python | 构建时安装 uv-managed Python 3.13 |
| VS Code | GUI 和连接扩展留在宿主机；容器只安装通用工作区扩展与对应语言扩展 |
| 环境验收 | 镜像内置 `check-env`，缺少必需工具时返回非零状态 |

更多容器布局和版本决策见 [容器说明](../../containers/README.md)。

## 参考

- [Dev Containers 官方镜像仓库](https://github.com/devcontainers/images)
- [VS Code：在容器中共享 Git 凭据与 SSH agent](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials)
- [PyTorch 官方镜像 tags](https://hub.docker.com/r/pytorch/pytorch/tags)
