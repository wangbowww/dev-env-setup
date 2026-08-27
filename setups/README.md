# Setup routes

选择一种开发环境并从对应路线开始：

- [macOS setup](macos/README.md)
- [Linux setup（Debian / Ubuntu）](linux/README.md)
- [Linux 容器 setup](container/README.md)

三条路线共用 [uv 常用命令](shared/uv-command-reference.md)。macOS/Linux 宿主机使用完整的 [VS Code 扩展清单](shared/vscode-extensions.txt)；容器按 C/C++、Go、PyTorch 分别安装工作区需要的扩展。宿主机路线在 GitHub SSH 后安装 dotfiles，容器路线在镜像构建时完成这一部分。
