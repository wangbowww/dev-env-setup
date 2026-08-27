# Linux 基础下载依赖

本页只安装后续获取和审阅官方软件所需的 HTTPS 证书、下载工具与基础文本工具，不一次性安装“常用工具大全”。

## 1. 更新 APT 索引

```bash
sudo apt update
```

先阅读错误和第三方源 warning，再继续。

## 2. 安装基础依赖

```bash
sudo apt install ca-certificates curl less vim zsh
```

检查：

```bash
curl --version
less --version
vim --version
zsh --version
dpkg -s ca-certificates
```

这里选择 Vim 和 Zsh 是因为个人 dotfiles 已经维护 `.vimrc` 与 `.zshrc`，后续路线会直接安装它们。`wget`、`tree`、`htop`、编译器等工具不在本页默认安装，需要时再单独审阅。

## 完成标准

- APT 索引更新成功。
- 系统 CA 证书、`curl`、`less`、Vim 和 Zsh 可用。

返回 [Linux setup 路线](README.md) 查看下一项。
