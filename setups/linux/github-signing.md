# Linux GitHub SSH 提交签名

沿用认证密钥 `~/.ssh/github-key` 做 SSH 提交签名。它需要在 GitHub 中再添加一次，这次 Key type 选择 `Signing Key`。

## 1. 前置检查

```bash
git --version
ssh-add -l
ls -l "$HOME/.ssh/github-key" "$HOME/.ssh/github-key.pub"
```

Git 必须是 2.34 或更高版本，私钥必须可用。

## 2. 添加 Signing Key

```bash
cat "$HOME/.ssh/github-key.pub"
```

复制完整公钥，在 GitHub 的 `Settings` → `SSH and GPG keys` → `New SSH key` 中选择 `Signing Key`。同一公钥同时出现 Authentication 和 Signing 两种记录是预期结果。

## 3. 配置和测试

```bash
git config --global gpg.format ssh
git config --global user.signingkey "$HOME/.ssh/github-key"
```

在确实有改动需要提交或专门的测试仓库中创建一次签名提交：

```bash
git commit -S -m "test: verify SSH commit signing"
```

推送后确认 GitHub 显示 `Verified`，再启用默认签名：

```bash
git config --global commit.gpgsign true
git config --global tag.gpgSign true
```

检查：

```bash
git config --global --get gpg.format
git config --global --get user.signingkey
git config --global --get commit.gpgsign
git config --global --get tag.gpgSign
```

本阶段不维护本地 `gpg.ssh.allowedSignersFile`；GitHub 页面上的 `Verified` 是本路线的验收结果。

## 完成标准

- 同一公钥已分别注册为 Authentication Key 和 Signing Key。
- 测试提交在 GitHub 显示 `Verified`。
- 测试成功后才启用 commit/tag 默认签名。

返回 [Linux setup 路线](README.md) 查看下一项。

## 参考

- [GitHub：SSH 提交签名](https://docs.github.com/en/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)
- [Git：SSH signing 配置](https://git-scm.com/docs/git-config)
