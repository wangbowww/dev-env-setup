# Linux Git

## 1. 安装

```bash
sudo apt install git
git --version
command -v git
```

SSH 提交签名需要 Git 2.34 或更高版本。如果发行版提供的版本更旧，先停止签名步骤；不要未经审阅添加第三方 PPA。

## 2. 配置提交身份

将占位符替换为希望写入提交历史的姓名，以及 GitHub 已验证邮箱：

```bash
git config --global user.name "YOUR NAME"
git config --global user.email "YOUR VERIFIED EMAIL"
```

检查：

```bash
git config --global --get user.name
git config --global --get user.email
git config --list --show-origin
```

默认分支、pull 策略和默认编辑器继续保留为待审阅的工作流偏好，不照搬通用模板。

## 完成标准

- Git 版本已记录，且签名步骤所需版本不低于 2.34。
- 姓名和邮箱正确，邮箱已关联 GitHub 账号。

返回 [Linux setup 路线](README.md) 查看下一项。

## 参考

- [Pro Git：首次配置 Git](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)
