# Linux dotfiles

完成 GitHub SSH 认证后，进入独立的 [dotfiles 仓库](https://github.com/wangbowww/dotfiles)，按照该仓库的 README 审阅并安装 Zsh、Vim 和机器本地配置入口。

dotfiles 仓库本身不限定存放位置；本路线按个人目录约定放在 `~/Codes/dotfiles`，执行 README 命令时相应替换示例路径。dotfiles 是配置及安装行为的唯一来源，本仓库不复制 `.zshrc`、`.vimrc` 或安装脚本。

安装脚本会把配置复制到 Home。目标文件内容不同时会先创建带时间戳的备份；`~/.zshrc.local` 已存在时不会被覆盖。

## 完成标准

- `zsh` 和 `vim` 已安装。
- `~/.zshrc` 和 `~/.vimrc` 由 dotfiles 仓库提供。
- `~/.zshrc.local` 已存在，权限为 `600`，且没有被提交到公开仓库。
- 新终端能够正常进入 Zsh，Vim 能够正常启动。

完成后返回 [Linux setup 路线](README.md) 查看下一项。
