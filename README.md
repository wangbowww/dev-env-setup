# personal-dev-envs

我的个人开发环境安装与配置手册。仓库提供三条明确的 setup 路线：macOS 宿主机、Linux 宿主机和 Linux 容器。

安装过程以文档为主，按顺序逐项执行。目标不是用脚本一次性修改整台机器，而是省去重复搜索资料，同时保留每一步的知情和审阅。

## 选择 setup 路线

| 路线 | 适用环境 | 状态 | 开始 |
| --- | --- | --- | --- |
| macOS | Apple Silicon Mac | 根据当前个人 Mac 整理并核对 | [进入 macOS setup](setups/macos/README.md) |
| Linux | Debian / Ubuntu，`amd64` 或 `arm64` | 已完成文档设计，待真实新环境验收 | [进入 Linux setup](setups/linux/README.md) |
| Linux 容器 | macOS/Linux 宿主机上的 C/C++、Go 或 PyTorch 环境 | 配置已重构，待实际构建验收 | [进入容器 setup](setups/container/README.md) |

其他 Linux 发行版暂不直接套用 Debian/Ubuntu 的 APT 命令。Windows 也不在当前宿主机 setup 范围内。

## 两条宿主机执行路线

| 顺序 | macOS | Linux |
| --- | --- | --- |
| 1 | [系统、Command Line Tools 与目录](setups/macos/system-and-directories.md) | [发行版、权限与目录](setups/linux/system-and-directories.md) |
| 2 | [Homebrew](setups/macos/homebrew.md) | [APT 基础下载依赖](setups/linux/system-packages.md) |
| 3 | [Git](setups/macos/git.md) | [Git](setups/linux/git.md) |
| 4 | [GitHub SSH 认证](setups/macos/github-ssh.md) | [GitHub SSH 认证](setups/linux/github-ssh.md) |
| 5 | [dotfiles](setups/macos/dotfiles.md) | [dotfiles](setups/linux/dotfiles.md) |
| 6 | [GitHub SSH 提交签名](setups/macos/github-signing.md) | [GitHub SSH 提交签名](setups/linux/github-signing.md) |
| 7 | [uv 与 Python](setups/macos/uv-python.md) | [uv 与 Python](setups/linux/uv-python.md) |
| 8 | [Visual Studio Code](setups/macos/vscode.md) | [Visual Studio Code（仅桌面 Linux）](setups/linux/vscode.md) |

无桌面的远程 Linux 服务器一般在第 7 步结束，不应为了完成清单而安装 GUI。选择容器开发时直接遵循第三条 [Linux 容器路线](setups/container/README.md)，不需要先完成 Linux 宿主机路线再进入容器重做一次。

## 跨系统保持一致的个人约定

- 所有项目代码放在 `~/Codes`。
- 个人工具链数据放在 `~/Toolchains`。
- GitHub SSH 密钥使用 `~/.ssh/github-key`。
- 同一个 GitHub SSH 公钥分别注册为 Authentication Key 和 Signing Key。
- Python 由 uv 管理，数据集中在 `~/Toolchains/uv`。
- 项目创建和依赖管理使用同一份 [uv 常用命令速查](setups/shared/uv-command-reference.md)。
- macOS/Linux 宿主机使用同一份 [VS Code 扩展基线](setups/shared/vscode-extensions.txt)。
- devcontainer 只安装当前语言和容器工作区真正需要的扩展，不照搬宿主机清单。
- VS Code User Settings 通过账户同步，不提交到本仓库。
- `.zshrc`、`.vimrc` 等由独立 dotfiles 仓库维护。

## 仓库结构

```text
personal-dev-envs/
├── README.md
├── setups/
│   ├── macos/       # macOS 从零安装路线
│   ├── linux/       # Debian/Ubuntu 从零安装路线
│   ├── container/   # Linux 容器 setup 路线
│   └── shared/      # 三条路线共同使用的清单
├── containers/
│   ├── common/      # 三套镜像共用的 Linux setup
│   ├── cpp/
│   ├── go/
│   └── pytorch/
└── docs/
    ├── dotfiles/    # dotfiles 边界与审阅说明
    └── containers/  # 容器设计说明
```

## 执行原则

- 先阅读当前页面，再逐条执行命令。
- 每页完成“完成标准”后再进入下一页。
- 占位符必须替换，不能原样执行。
- 密钥、令牌、代理地址、远程主机和机器私有设置不能提交。
- 软件版本或安装来源发生变化时，先核对官方文档再更新本手册。
- dotfiles 由独立仓库维护；容器作为独立路线保留，不因当前暂时不用而删除。
