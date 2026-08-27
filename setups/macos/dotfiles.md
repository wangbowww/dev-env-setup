# macOS dotfiles

完成 GitHub SSH 认证后，进入独立的 [dotfiles 仓库](https://github.com/wangbowww/dotfiles)，按照该仓库的 README 审阅并安装 Zsh、Vim 和机器本地配置入口。

dotfiles 仓库是这些文件的唯一来源；本仓库不复制 `.zshrc`、`.vimrc` 或安装脚本。安装前应先确认脚本对已有配置文件的处理方式。

## 完成标准

- `~/.zshrc` 和 `~/.vimrc` 由 dotfiles 仓库提供。
- `~/.zshrc.local` 已存在，权限为 `600`，且没有被提交到公开仓库。
- 新终端能够正常进入 Zsh，Vim 能够正常启动。

完成后返回 [macOS setup 路线](README.md) 查看下一项。
