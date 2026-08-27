# GitHub SSH 认证

本页配置“这台 Mac 可以通过 SSH 访问 GitHub”。它先解决仓库认证；下一页会把同一把公钥再注册为 Signing Key。

个人约定的认证密钥名：

```text
~/.ssh/github-key
```

## 1. 检查已有密钥

```bash
ls -al "$HOME/.ssh" 2>/dev/null
```

如果 `github-key` 已存在，不要重新运行生成命令，也不要覆盖私钥。应先确认它是否仍在使用、是否有安全备份，以及 GitHub 账号中是否已有对应公钥。

## 2. 生成认证密钥

将邮箱替换为 GitHub 已验证邮箱：

```bash
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
ssh-keygen -t ed25519 -C "YOUR VERIFIED EMAIL" -f "$HOME/.ssh/github-key"
```

建议设置强口令，并交给 macOS Keychain 保存。私钥 `github-key` 不能上传、复制到聊天或提交到仓库；只上传带 `.pub` 后缀的公钥。

## 3. 配置 macOS ssh-agent

在 `~/.ssh/config` 中合并下面的配置；如果文件已有内容，不要整文件覆盖：

```bash
touch "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"
vim "$HOME/.ssh/config"
```

```sshconfig
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/github-key
  IdentitiesOnly yes
```

使用 macOS 自带的 `ssh-add` 将私钥加入 Keychain：

```bash
/usr/bin/ssh-add --apple-use-keychain "$HOME/.ssh/github-key"
```

如果创建密钥时明确选择了无口令密钥，应去掉 `UseKeychain yes`，并使用普通的 `/usr/bin/ssh-add`；但个人开发机器默认推荐设置口令。

## 4. 添加公钥到 GitHub

复制公钥：

```bash
pbcopy < "$HOME/.ssh/github-key.pub"
```

打开 GitHub：`Settings` → `SSH and GPG keys` → `New SSH key`：

- Title 使用能识别机器的名称，例如 `MacBook Pro authentication`。
- Key type 选择 `Authentication Key`。
- Key 粘贴刚刚复制的公钥。

## 5. 测试连接

```bash
ssh -T git@github.com
```

第一次连接时要核对 GitHub 的主机指纹，再决定是否接受。成功后 GitHub 会显示已认证，但不提供 shell access；这是正常结果。

## 6. 将已有仓库切换为 SSH

先查看当前 remote：

```bash
git remote -v
```

确认 owner 和仓库名后再修改：

```bash
git remote set-url origin git@github.com:OWNER/REPOSITORY.git
git remote -v
```

不要在不确认仓库归属时直接复制示例地址。

## 7. 完成标准

- 认证私钥权限正确且未进入任何仓库。
- GitHub 中公钥类型为 `Authentication Key`。
- `ssh -T git@github.com` 能识别正确账号。
- 目标仓库的 remote 已按需改成 SSH。

返回 [macOS setup 路线](README.md) 查看下一项。

## 参考

- [GitHub：生成 SSH 密钥并加入 ssh-agent](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- [GitHub：添加 SSH 密钥到账户](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
- [GitHub：测试 SSH 连接](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/testing-your-ssh-connection)
- [GitHub 公布的 SSH 主机指纹](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/githubs-ssh-key-fingerprints)
