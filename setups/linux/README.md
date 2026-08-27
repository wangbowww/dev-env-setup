# Linux setup 路线

这条路线用于 Debian/Ubuntu 系 Linux。它根据当前 macOS 使用习惯、远程 Linux 开发方式和仓库中的 Debian 容器整理而成，尚未在一台全新的 Linux 宿主机上完整验收。

## 适用范围

- Debian 12 或较新的 Debian 系统
- 当前受支持的 Ubuntu LTS
- `amd64` 或 `arm64`
- 普通用户可以使用 `sudo`

Fedora、RHEL、Arch、NixOS 和其他发行版暂不直接套用这里的 APT 命令。

## 与 macOS 保持一致的个人约定

- 代码目录：`~/Codes`
- 工具链目录：`~/Toolchains`
- GitHub 密钥：`~/.ssh/github-key`
- Python：uv 管理，数据位于 `~/Toolchains/uv`
- VS Code 扩展：使用仓库中的同一份已确认清单
- Shell 配置：在 GitHub SSH 之后按独立 dotfiles 仓库安装

## 按顺序执行

1. [检查发行版、权限并创建目录](system-and-directories.md)
2. [安装基础下载依赖](system-packages.md)
3. [安装和配置 Git](git.md)
4. [配置 GitHub SSH 认证](github-ssh.md)
5. [安装 dotfiles](dotfiles.md)
6. [配置 GitHub SSH 提交签名](github-signing.md)
7. [安装 uv 与 Python](uv-python.md)
8. [安装 Visual Studio Code](vscode.md)

无桌面的远程 Linux 服务器通常执行到第 7 步即可；不要为了满足这条路线安装桌面环境或 VS Code GUI。SSH server 的开放、端口和防火墙属于服务器安全配置，本路线不自动处理。

如果选择以容器作为开发环境，请单独遵循 [Linux 容器 setup](../container/README.md)，不要在容器中重走本路线。

## 验收状态

目前这些文档完成了命令与官方资料核对，但仍需要在真实 Debian/Ubuntu 新环境中逐页执行。验收过程中发现的发行版差异应记录回对应页面。

完成 uv 安装后，可随时打开 [uv 项目创建与常用命令](../shared/uv-command-reference.md) 快速创建或恢复项目环境。
