# macOS setup 路线

这条路线来自当前 Apple Silicon Mac 的实际环境，适合安装一台新的个人 macOS 开发机。

## 路线状态

- 目标架构：Apple Silicon (`arm64`)
- 包管理器：Homebrew
- 代码目录：`~/Codes`
- 工具链目录：`~/Toolchains`
- Python：uv 管理，数据位于 `~/Toolchains/uv`
- 编辑器：VS Code 官方 DMG + 已确认扩展清单 + Settings Sync
- Shell 配置：在 GitHub SSH 之后按独立 dotfiles 仓库安装

## 按顺序执行

1. [系统检查、Command Line Tools 与目录](system-and-directories.md)
2. [Homebrew](homebrew.md)
3. [Git](git.md)
4. [GitHub SSH 认证](github-ssh.md)
5. [dotfiles](dotfiles.md)
6. [GitHub SSH 提交签名](github-signing.md)
7. [uv 与 Python](uv-python.md)
8. [Visual Studio Code](vscode.md)

每完成一页的“完成标准”再进入下一页。dotfiles 的内容仍在独立仓库审阅，但它现在是正式路线中的前置步骤。

如果选择以容器作为开发环境，请单独遵循 [Linux 容器 setup](../container/README.md)，不要在容器中重走 Linux setup。

完成 uv 安装后，可随时打开 [uv 项目创建与常用命令](../shared/uv-command-reference.md) 快速创建或恢复项目环境。
