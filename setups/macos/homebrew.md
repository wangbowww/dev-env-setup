# Homebrew

Homebrew 用来管理命令行工具。图形应用是否交给 Homebrew Cask 管理，需要按软件逐项决定，不能因为用了 Homebrew 就默认接管所有应用。

## 1. 安装前检查

```bash
command -v brew
brew --version
```

如果两条命令都正常，不要重复安装，直接进入“验证安装位置”。

## 2. 阅读官方安装脚本

官方一行命令会下载并执行远程脚本。执行前可以先在浏览器打开脚本地址，或者先下载到临时文件自行阅读。

确认后，使用 Homebrew 官方交互式安装命令：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

安装器会先说明准备执行的操作并等待确认。本项目不使用 `NONINTERACTIVE=1`。

## 3. 配置当前 Shell

Apple Silicon 的受支持默认位置是 `/opt/homebrew`。先在当前终端载入：

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

要让新终端也能找到 Homebrew，在 `~/.zprofile` 中保留下面这一行：

```bash
eval "$(/opt/homebrew/bin/brew shellenv)"
```

编辑前先检查，避免重复添加；文件不存在时再创建：

```bash
grep -n 'brew shellenv' "$HOME/.zprofile" 2>/dev/null
touch "$HOME/.zprofile"
vim "$HOME/.zprofile"
```

`~/.zprofile` 的最终归属会在 dotfiles 审阅时再次确认。

## 4. 验证安装位置

```bash
command -v brew
brew --prefix
brew doctor
```

Apple Silicon 的预期结果是：

```text
/opt/homebrew/bin/brew
/opt/homebrew
```

`brew doctor` 的 warning 需要逐条阅读，不建议看到 warning 就盲目执行清理命令。

## 5. 日常维护

先查看将要更新的内容：

```bash
brew update
brew outdated
```

确认后再更新：

```bash
brew upgrade
```

查看由自己直接安装的顶层工具：

```bash
brew leaves
brew list --cask
```

本项目暂不引入一个包含所有软件的 `Brewfile`，因为逐页、逐项安装更符合当前的审阅方式。以后如果软件清单稳定，可以再评估是否补充只用于审计的 Brewfile。

## 6. 完成标准

- `command -v brew` 指向预期路径。
- `brew --prefix` 与机器架构一致。
- 已阅读 `brew doctor` 的输出。

返回 [macOS setup 路线](README.md) 查看下一项。

## 参考

- [Homebrew 官网与官方安装命令](https://brew.sh/)
- [Homebrew 安装说明](https://docs.brew.sh/Installation)
