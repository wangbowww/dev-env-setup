# Visual Studio Code

当前个人环境中的 VS Code 是放在 `/Applications` 的官方应用，不由 Homebrew Cask 管理。新机器继续沿用官方 DMG 安装方式；是否改由 Homebrew 管理以后再单独决定。

## 1. 安装应用

1. 打开 [VS Code 官方 macOS 安装页](https://code.visualstudio.com/docs/setup/mac)。
2. 下载适合当前 Mac 的构建；Apple Silicon 机器选择 Apple silicon 或 Universal。
3. 打开 DMG，将 `Visual Studio Code.app` 拖到 `/Applications`。
4. 从 Applications 首次启动，确认 macOS 安全提示。

本项目不提供第三方下载链接，也不默认执行 `brew install --cask visual-studio-code`。

## 2. 安装 `code` 命令

在 VS Code 中按 `Cmd+Shift+P` 打开 Command Palette，执行：

```text
Shell Command: Install 'code' command in PATH
```

重开终端后验证：

```bash
command -v code
code --version
```

然后可以在项目目录运行：

```bash
code .
```

## 3. 安装已确认的扩展

当前机器上的完整扩展清单已经确认为新机安装基线，保存在 [vscode-extensions.txt](../shared/vscode-extensions.txt)。清单只固定扩展 ID，不固定版本；安装时由 Marketplace 选择与当前 VS Code 兼容的版本。

| 类别 | 扩展 |
| --- | --- |
| Codex | `openai.chatgpt`、`martinortiz.codex-stats` |
| Python / Jupyter | `ms-python.python`、`ms-python.vscode-pylance`、`ms-python.debugpy`、`ms-python.vscode-python-envs`、`ms-toolsai.jupyter-keymap` |
| C++ | `llvm-vs-code-extensions.vscode-clangd`、`ms-vscode.cmake-tools`、`vadimcn.vscode-lldb` |
| Remote Development | `ms-vscode-remote.remote-ssh`、`ms-vscode-remote.remote-ssh-edit`、`ms-vscode-remote.vscode-remote-extensionpack`、`ms-vscode.remote-explorer`、`ms-vscode.remote-server` |
| Containers | `ms-vscode-remote.remote-containers`、`ms-azuretools.vscode-containers` |
| GitHub | `github.remotehub`、`github.vscode-github-actions`、`ms-vscode.remote-repositories` |
| 界面与文档 | `ms-ceintl.vscode-language-pack-zh-hans`、`tomoki1207.pdf` |

从仓库根目录执行，按照清单逐个安装：

```bash
while IFS= read -r extension_id; do
  code --install-extension "$extension_id"
done < setups/shared/vscode-extensions.txt
```

当前 CMake Tools 还会将 `ms-vscode.cpp-devtools` 作为 extension pack 内容自动安装；它不是这套个人配置主动选择的 C++ 扩展。完成清单安装后检查并移除它：

```bash
code --uninstall-extension ms-vscode.cpp-devtools
```

移除 extension pack 内容不会卸载 CMake Tools。本配置继续由 clangd 提供 C++ 语言服务。

重复执行不会有意安装第二份扩展。安装完成后比较实际状态和基线：

```bash
comm -3 \
  setups/shared/vscode-extensions.txt \
  <(code --list-extensions | sort)
```

没有输出表示两边一致。以后新增或删除扩展时，应同时更新清单。

Settings Sync 也能同步扩展，但本项目仍保留这份明确清单，使扩展基线可以在不登录账号时审阅和恢复。Remote SSH、devcontainer 或 WSL 窗口中的远程扩展不会由本地 Settings Sync 自动同步，需要在对应远程环境中按需安装。

## 4. 通过账户同步用户设置

VS Code 的 User Settings 不提交到本仓库，使用内置 Settings Sync 恢复：

1. 打开左下角 Accounts 或 Manage 菜单。
2. 选择 `Backup and Sync Settings...`。
3. 使用原来保存设置的同一个 GitHub 或 Microsoft 账号登录。
4. 在同步内容中至少启用 `Settings`。
5. 扩展已经由本仓库清单管理，可在 `Settings Sync: Configure` 中取消 `Extensions`，避免出现两个来源。

在全新的 VS Code 上，如果云端设置就是唯一基线，可以选择 `Replace Local`；如果本机已经修改过设置，选择 `Merge Manually...` 并逐项确认，不要直接覆盖。

同步完成后，从 Command Palette 执行：

```text
Settings Sync: Show Synced Data
```

确认用户设置已经恢复。VS Code 默认不会同步带有 `machine` 或 `machine-overridable` scope 的机器专属设置；需要跨机器的例外可以通过 `settingsSync.ignoredSettings` 单独调整。

这套边界是：

- 扩展基线：仓库中的 `vscode-extensions.txt`
- User Settings：VS Code 账户同步
- Workspace Settings：按项目提交到各项目自己的 `.vscode/settings.json`
- SSH 主机、凭据和其他秘密：保留在机器本地，不能进入本仓库

## 5. 完成标准

- 应用位于 `/Applications/Visual Studio Code.app`。
- `code --version` 正常输出。
- `code --list-extensions` 与 `vscode-extensions.txt` 一致。
- Settings Sync 使用正确账号，User Settings 已恢复。
- 没有把远程主机、凭据或其他机器私有设置提交到仓库。

至此 macOS 宿主机基础路线完成。需要容器开发环境时，单独进入 [Linux 容器 setup](../container/README.md)。

## 参考

- [VS Code：在 macOS 上安装](https://code.visualstudio.com/docs/setup/mac)
- [VS Code：命令行界面](https://code.visualstudio.com/docs/configure/command-line)
- [VS Code：扩展管理](https://code.visualstudio.com/docs/configure/extensions/extension-marketplace)
- [VS Code：Settings Sync](https://code.visualstudio.com/docs/configure/settings-sync)
