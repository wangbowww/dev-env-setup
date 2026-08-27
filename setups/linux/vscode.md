# Linux Visual Studio Code

本页只适用于有桌面环境的 Debian/Ubuntu 开发机。无桌面服务器跳过，不安装 VS Code GUI。

## 1. 安装官方 `.deb`

确认架构：

```bash
dpkg --print-architecture
```

从 [VS Code 官方 Linux 下载页](https://code.visualstudio.com/docs/setup/linux) 下载与架构匹配的 `.deb` 到 `~/Downloads`。先确认实际文件名：

```bash
find "$HOME/Downloads" -maxdepth 1 -type f -name 'code_*.deb' -print
```

将下面的占位符替换成刚才确认的完整文件名：

```bash
sudo apt install "$HOME/Downloads/ACTUAL_CODE_PACKAGE.deb"
```

安装过程可能询问是否添加 Microsoft 官方 APT repository 和 signing key。个人开发机选择添加，以后 VS Code 随 APT 更新；执行前阅读提示并确认来源是 `packages.microsoft.com`。

验证：

```bash
command -v code
code --version
```

## 2. 安装统一扩展基线

扩展清单与 macOS 共用：[vscode-extensions.txt](../shared/vscode-extensions.txt)。从仓库根目录执行：

```bash
while IFS= read -r extension_id; do
  code --install-extension "$extension_id"
done < setups/shared/vscode-extensions.txt
```

检查差异：

```bash
comm -3 \
  setups/shared/vscode-extensions.txt \
  <(code --list-extensions | sort)
```

没有输出表示完全一致。Remote SSH、devcontainer 内部的远程扩展需要在对应远程环境中按需安装，Settings Sync 不会自动把本地扩展同步到远程窗口。

## 3. 恢复 User Settings

1. 打开 Accounts 或 Manage 菜单。
2. 选择 `Backup and Sync Settings...`。
3. 使用原来保存设置的同一个 GitHub 或 Microsoft 账号登录。
4. 至少启用 `Settings`；扩展由仓库清单管理，可以取消 `Extensions`。
5. 全新安装可用 `Replace Local` 恢复云端基线；已有本地设置时选择 `Merge Manually...`。

通过 `Settings Sync: Show Synced Data` 检查同步结果。带 `machine` 或 `machine-overridable` scope 的设置默认不会跨机器同步。

## 完成标准

- `code --version` 正常。
- 实际扩展和共享清单一致。
- User Settings 已通过正确账号恢复。
- 没有把机器私有设置或凭据提交到仓库。

至此 Linux 宿主机基础路线完成。需要容器开发环境时，单独进入 [Linux 容器 setup](../container/README.md)。

## 参考

- [VS Code：Linux 安装](https://code.visualstudio.com/docs/setup/linux)
- [VS Code：Settings Sync](https://code.visualstudio.com/docs/configure/settings-sync)
