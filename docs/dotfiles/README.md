# dotfiles 边界与审阅入口

dotfiles 的内容继续在独立仓库中单独审阅，但安装时机已经进入 macOS 和 Linux 的正式 setup 路线：完成 GitHub SSH 后、配置 signing 与 uv 前。

## 仓库边界

独立仓库位置：

```text
~/Codes/dotfiles
```

公开入口：[wangbowww/dotfiles](https://github.com/wangbowww/dotfiles)

它继续负责：

- `.zshrc` 与 Zsh prompt、插件、历史和快捷键
- `.vimrc`
- Oh My Zsh 和相关插件的安装
- `~/.zshrc.local` 这个机器本地配置入口

本仓库负责说明何时需要 dotfiles，以及它依赖哪些已经安装的软件；不复制 `.zshrc` 或 `.vimrc` 内容。

## 已发现的待审阅项

1. dotfiles README 要求运行 `./install.sh`，但仓库中实际只有 `install-zsh.sh` 与 `install-vim.sh`。
2. 两个安装脚本会删除并覆盖现有 `~/.zshrc` 或 `~/.vimrc`，尚未提供备份或 dry-run。
3. Oh My Zsh 安装使用下载后直接执行的远程脚本，需要确认信任与失败恢复方式。
4. `~/.zshrc.local` 适合保存 uv 路径和机器私有代理，但应明确哪些变量属于通用配置。
5. Homebrew 的 `brew shellenv` 当前计划写入 `~/.zprofile`，需要确认 dotfiles 是否也要管理该文件。
6. macOS 与 Linux 是否共享同一套安装流程，需要分别验证。

## 本仓库的边界

- 宿主机路线只链接到独立仓库，不复制或自动执行 dotfiles。
- Linux 容器构建会拉取经过明确固定的 dotfiles commit，使容器创建后可以直接使用。
- 不修改独立 dotfiles 仓库。
- 不把本机现有 `.zshrc.local` 的私有内容复制进文档。

审阅时应逐文件确认，再补充正式安装顺序和安全的迁移步骤。
