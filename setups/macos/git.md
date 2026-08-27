# Git

macOS Command Line Tools 自带 Git，但个人环境使用 Homebrew 版本，以便独立更新。安装软件和写入个人身份是两类操作，执行时分别确认。

## 1. 检查当前 Git

```bash
which -a git
git --version
```

同时出现 `/opt/homebrew/bin/git` 和 `/usr/bin/git` 是正常的；PATH 中排在前面的版本会被使用。

## 2. 安装 Homebrew Git

```bash
brew install git
```

验证：

```bash
command -v git
git --version
```

Apple Silicon 上期望优先使用 `/opt/homebrew/bin/git`。

## 3. 配置提交身份

先确认 GitHub 账号中已经验证的邮箱，再替换下面的占位符：

```bash
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR VERIFIED EMAIL"
```

这两个值会写入未来的每一个提交。不要为了隐藏邮箱随意填写不存在的地址；如果需要隐私，可使用 GitHub 为账号提供的 `noreply` 邮箱。

检查最终值及其来源：

```bash
git config --global --get user.name
git config --global --get user.email
git config --list --show-origin
```

## 4. 暂不统一的个人偏好

以下设置会改变日常 Git 工作流，本阶段不自动推荐具体值：

- 新仓库默认分支使用 `main` 还是 `master`
- `git pull` 默认 merge、rebase 还是仅允许 fast-forward
- 默认编辑器使用 Vim 还是 VS Code
- 是否启用全局 ignore 文件

这些偏好应该在实际工作流审阅后再加入，而不是照搬他人的 `.gitconfig`。

## 5. 完成标准

- `command -v git` 指向 Homebrew Git。
- `user.name` 是希望出现在提交历史中的姓名。
- `user.email` 已在 GitHub 账号中验证。

返回 [macOS setup 路线](README.md) 查看下一项。

## 参考

- [Pro Git：首次配置 Git](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)
- [GitHub：设置提交邮箱](https://docs.github.com/en/account-and-profile/how-tos/email-preferences/setting-your-commit-email-address)
