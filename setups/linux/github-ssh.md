# Linux GitHub SSH 认证

个人约定继续使用：

```text
~/.ssh/github-key
```

## 1. 安装并检查 SSH client

```bash
sudo apt install openssh-client
ssh -V
ls -al "$HOME/.ssh" 2>/dev/null
```

如果 `github-key` 已存在，不要覆盖。应先确认它是否仍在使用，以及 GitHub 账号中是否已有对应公钥。

## 2. 生成认证密钥

确认不存在后运行：

```bash
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
ssh-keygen -t ed25519 -C "YOUR VERIFIED EMAIL" -f "$HOME/.ssh/github-key"
```

建议设置强口令。私钥 `github-key` 不能上传或提交，只能把 `github-key.pub` 添加到 GitHub。

## 3. 配置 SSH

```bash
touch "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
vim "$HOME/.ssh/config"
```

合并下面的配置，不要覆盖文件中已有的其他主机：

```sshconfig
Host github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/github-key
  IdentitiesOnly yes
```

Linux 不使用 macOS 专属的 `UseKeychain` 和 `--apple-use-keychain`。

启动 agent 并加载密钥：

```bash
eval "$(ssh-agent -s)"
ssh-add "$HOME/.ssh/github-key"
ssh-add -l
```

不同桌面环境对登录后 ssh-agent 的管理方式不同，自动加载留到 Linux dotfiles 实机审阅时处理。

## 4. 添加 Authentication Key

显示公钥并手动复制完整一行：

```bash
cat "$HOME/.ssh/github-key.pub"
```

打开 GitHub：`Settings` → `SSH and GPG keys` → `New SSH key`，Key type 选择 `Authentication Key`。

## 5. 测试和切换 remote

```bash
ssh -T git@github.com
git remote -v
```

第一次连接要先对照 GitHub 官方主机指纹。需要切换已有仓库时，确认实际 owner 和仓库名后运行：

```bash
git remote set-url origin git@github.com:OWNER/REPOSITORY.git
```

## 完成标准

- 私钥权限正确且已加载到 ssh-agent。
- 公钥在 GitHub 中注册为 Authentication Key。
- `ssh -T git@github.com` 能识别正确账号。

返回 [Linux setup 路线](README.md) 查看下一项。

## 参考

- [GitHub：Linux 生成 SSH 密钥并加入 ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent?platform=linux)
- [GitHub：添加 SSH 密钥](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
- [GitHub SSH 主机指纹](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints)
