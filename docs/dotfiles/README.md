# dotfiles 边界

dotfiles 是完全独立的仓库。它不知道也不依赖 `dev-env-setup`；依赖只存在于本仓库这一侧。本仓库负责决定何时安装 dotfiles，具体配置和安装行为始终以 dotfiles 自己的 README 与脚本为准。

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

## 当前已确认的行为

- README 分别给出 `install-zsh.sh` 与 `install-vim.sh` 的审阅、安装和验证顺序。
- `.zshrc` 与 `.vimrc` 复制到 Home，不使用符号链接。
- 不同的已有目标文件会先移动为带时间戳的备份，再安装新文件。
- 相同目标文件会跳过复制，不创建重复备份。
- `~/.zshrc.local` 只在不存在时创建，已有文件不会被覆盖。
- Oh My Zsh 和插件直接通过 Git 克隆，不执行下载得到的远程安装脚本。
- 安装脚本已使用隔离 Home 验证备份、复制、权限和重复执行行为，并通过当前 macOS 自带 Bash 3.2 的语法与运行测试。

## 仍需在实际环境验收

- 在全新 macOS 主机上按 README 从克隆开始完整执行。
- 在全新 Debian/Ubuntu 主机上完整执行。
- Homebrew 的 `brew shellenv` 继续由 `~/.zprofile` 管理，是否纳入 dotfiles 留待以后单独决定。
- Oh My Zsh 和插件当前跟随克隆时的最新 commit；是否固定版本需要单独审阅。

## 本仓库的边界

- 宿主机路线只链接到独立仓库，不复制或自动执行 dotfiles。
- Linux 容器构建会由本仓库拉取经过明确固定的 dotfiles commit，使容器创建后可以直接使用。
- 不修改独立 dotfiles 仓库。
- 不把本机现有 `.zshrc.local` 的私有内容复制进文档。
