# Linux 系统检查与目录约定

## 1. 确认发行版和架构

```bash
cat /etc/os-release
uname -m
```

确认 `ID` 或 `ID_LIKE` 属于 Debian/Ubuntu 系，并记录架构是 `x86_64` 还是 `aarch64`。如果不是 APT 系发行版，停止使用本路线。

## 2. 确认当前用户

```bash
id
sudo -v
```

日常开发不应直接使用 root 用户。后续只有系统包安装使用 `sudo`，`~/Codes`、SSH 密钥和 uv 都归当前普通用户所有。

## 3. 创建个人目录

```bash
mkdir -p "$HOME/Codes"
mkdir -p "$HOME/Toolchains"
ls -ld "$HOME/Codes" "$HOME/Toolchains"
```

## 完成标准

- 已确认是受支持的 Debian/Ubuntu 系统。
- 当前使用普通用户，并具有需要时使用 `sudo` 的权限。
- `~/Codes` 和 `~/Toolchains` 已创建且归当前用户所有。

返回 [Linux setup 路线](README.md) 查看下一项。
