# Linux 容器设计说明

容器是与 macOS、Linux 宿主机并列的第三条 setup 路线，不再作为两条宿主机路线末尾的附加步骤。所有容器的 Container OS 都是 Linux。

## 构建关系

| 环境 | 基础镜像 | 构建入口 | 架构 |
| --- | --- | --- | --- |
| C/C++ | Microsoft Dev Containers `cpp:bookworm` | `containers/cpp/Dockerfile` | `amd64`、`arm64` |
| Go | Microsoft Dev Containers `go:1.26-bookworm` | `containers/go/Dockerfile` | `amd64`、`arm64` |
| PyTorch | PyTorch `2.8.0-cuda12.8-cudnn9-runtime` | `containers/pytorch/Dockerfile` | `amd64` + NVIDIA GPU |

devcontainer 使用 `build.dockerfile` 和仓库根目录 build context，保证 `containers/common/install-linux-setup.sh` 真正参与构建。个人 Docker Hub 镜像已从构建链路中移除。

## 与 Linux setup 的关系

公共脚本在镜像构建阶段完成：

- APT 基础工具、Git、OpenSSH client、Zsh 和 Vim。
- `/root/Codes` 与 `/root/Toolchains/uv` 目录布局。
- dotfiles 仓库固定 commit 对应的 Zsh、Vim、Oh My Zsh 与插件。
- uv standalone installer、自定义存储变量和 uv-managed Python 3.13。

每个 devcontainer 只安装容器工作区需要的扩展和对应语言扩展。Remote SSH、Dev Containers、中文语言包等宿主机 UI/连接扩展不重复安装进容器，C/C++ 与 Go 容器也不安装 Python/Jupyter 扩展。因此创建容器后不应再执行 `setups/linux/`。

镜像内的 `/usr/local/bin/check-env` 会按 `PERSONAL_DEV_PROFILE` 检查公共 Linux setup、语言工具链、uv、dotfiles、宿主机身份接入和 VS Code 扩展。必需环境缺失会返回非零状态；账号、agent、GPU 或 VS Code 尚未接入只会产生 warning。

## 有意保留在镜像外的状态

- GitHub SSH 私钥只留在宿主机，通过 VS Code 转发的 SSH agent 使用。
- Git 身份和 signing 设置复用宿主机 `.gitconfig`。
- `github-key.pub` 以只读方式挂载，并在容器内配置为 signing key 路径。
- VS Code User Settings 和登录状态继续由账户同步负责。
- 代理、令牌、私有索引和远程主机配置不进入镜像。

这不是“容器缺少 Linux setup”，而是秘密与账号状态的安全边界。

## 版本策略与已知限制

- C/C++ 和 Go 固定 Debian `bookworm`，避免无意切换发行版。
- Go 固定语言版本 1.26，但现有 Go 辅助工具仍使用 `@latest`，后续应逐个决定是否锁版本。
- PyTorch 保留已有的 2.8/CUDA 12.8 组合，改用官方公开镜像；镜像只有 `linux/amd64`，且需要 NVIDIA Container Toolkit。
- dotfiles 固定到 commit `c51f5edec824176f660456084b348b5807cc69ad`；审阅独立仓库更新后，再显式更新 Dockerfile 参数。
- uv 安装脚本和 Python 3.13 patch release 当前未锁 digest/patch，后续可以单独决定更严格的可复现策略。
- 当前 Mac 没有可用 Docker CLI，因此本轮只能静态验证 Dockerfile、脚本和 devcontainer 配置，仍需在实际容器运行时上构建验收。

使用步骤见 [Linux 容器 setup 路线](../../setups/container/README.md)。

## 参考

- [Dev Containers 官方公开镜像](https://github.com/devcontainers/images)
- [Go Dev Container 镜像与版本说明](https://github.com/devcontainers/images/blob/main/src/go/README.md)
- [VS Code：在容器中共享 Git 凭据与 SSH agent](https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials)
- [PyTorch 官方 Docker Hub tags](https://hub.docker.com/r/pytorch/pytorch/tags)
