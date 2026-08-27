# GitHub SSH 提交签名

GitHub 支持 GPG、SSH 和 S/MIME 提交签名。个人环境选择 SSH 签名，因为它不需要额外安装 GPG 工具，并且 GitHub 将它列为个人用户最简单的选择之一。

当前个人配置复用认证密钥：

```text
~/.ssh/github-key
```

同一个公钥需要在 GitHub 中添加两次，一次作为 `Authentication Key`，一次作为 `Signing Key`。这样配置简单，但认证密钥轮换时也要同步更新签名配置。是否改用独立签名密钥，留到未来单独审阅。

## 1. 检查 Git 与现有密钥

SSH 签名需要 Git 2.34 或更高版本：

```bash
git --version
ls -l "$HOME/.ssh/github-key" "$HOME/.ssh/github-key.pub"
```

如果密钥不存在，先完成 [GitHub SSH 认证](github-ssh.md)，不要在这里生成第二把未经审阅的密钥。

确认认证密钥已经载入当前 ssh-agent：

```bash
/usr/bin/ssh-add -l
```

如果没有载入：

```bash
/usr/bin/ssh-add --apple-use-keychain "$HOME/.ssh/github-key"
```

## 2. 将同一公钥添加为 Signing Key

复制公钥：

```bash
pbcopy < "$HOME/.ssh/github-key.pub"
```

打开 GitHub：`Settings` → `SSH and GPG keys` → `New SSH key`：

- Title 使用例如 `MacBook Pro signing`。
- Key type 必须选择 `Signing Key`。
- Key 粘贴刚刚复制的公钥。

此时同一公钥会在 GitHub 设置中出现两次，但类型不同，这是预期结果。不要上传私钥。

## 3. 告诉 Git 使用 SSH 签名

当前个人配置让 Git 直接引用私钥路径：

```bash
git config --global gpg.format ssh
git config --global user.signingkey "$HOME/.ssh/github-key"
```

Git 也支持在私钥已加载到 ssh-agent 时配置 `.pub` 公钥路径，但本手册先忠实记录当前使用方式，不混用两种方案。

## 4. 测试后启用默认签名

先在专门用于测试或确实有改动要提交的仓库中手动签署一次：

```bash
git commit -S -m "test: verify SSH commit signing"
```

这条命令会创建真实提交，不能在仅做检查时运行。

推送后确认 GitHub 提交页面显示 `Verified`。测试成功，再启用所有提交和标签的默认签名：

```bash
git config --global commit.gpgsign true
git config --global tag.gpgSign true
```

当前个人机器已经启用了这两个设置；新机器仍应按“先测试、后启用”的顺序操作。

## 5. 验证配置

```bash
git config --global --get gpg.format
git config --global --get user.signingkey
git config --global --get commit.gpgsign
git config --global --get tag.gpgSign
```

预期值分别是 `ssh`、`~/.ssh/github-key` 对应的绝对路径，以及两个 `true`。

本地 `git show --show-signature -1` 可以确认提交带有 SSH 签名。如果没有配置 `gpg.ssh.allowedSignersFile`，本地可能不会把签名者标记为受信任；这不等同于 GitHub 验证失败。本阶段不额外维护 allowed signers 文件。

同时确认提交所用的 `user.email` 已在 GitHub 账号中验证。

## 6. 备份与轮换原则

- 私钥不能提交到 Git、云盘同步目录或公开笔记。
- 重装机器时，可以安全迁移已有私钥，也可以生成新密钥并在 GitHub 上撤销旧密钥。
- 因为当前认证和签名共用密钥，轮换时必须同时更新 GitHub 中的 Authentication Key、Signing Key 和本地 `user.signingkey`。
- 删除或丢失私钥不会改变过去提交中的签名，但会影响以后继续使用同一密钥签名。

## 7. 完成标准

- 同一公钥在 GitHub 中分别注册为 Authentication Key 和 Signing Key。
- Git 配置使用 `gpg.format=ssh`。
- 测试提交在 GitHub 上显示 `Verified`。
- 测试成功后才启用默认提交和标签签名。

返回 [macOS setup 路线](README.md) 查看下一项。

## 参考

- [GitHub：关于提交签名验证](https://docs.github.com/en/authentication/managing-commit-signature-verification/about-commit-signature-verification)
- [GitHub：添加 SSH 密钥到账户](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account)
- [GitHub：告诉 Git 使用 SSH 签名密钥](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)
- [GitHub：签署提交](https://docs.github.com/en/authentication/managing-commit-signature-verification/signing-commits)
- [Git：`user.signingKey` 与 SSH 签名配置](https://git-scm.com/docs/git-config)
