# 容器开发环境

三套开箱即用的 Linux 容器开发环境集中放在这个目录中：

```text
containers/
├── common/
│   ├── check-environment.sh
│   └── install-linux-setup.sh
├── cpp/
│   ├── .devcontainer/
│   ├── Dockerfile
│   └── examples/
├── go/
│   ├── .devcontainer/
│   ├── Dockerfile
│   └── examples/
└── pytorch/
    ├── .devcontainer/
    ├── Dockerfile
    └── examples/
```

在 VS Code 中打开某个环境目录，例如 `containers/go`，即可让 Dev Containers 扩展发现该目录下的 `.devcontainer/devcontainer.json`，并从本仓库 Dockerfile 构建镜像。

公共安装脚本会在构建时安装 Linux 基础工具、固定版本的 dotfiles、uv、自定义存储目录和受 uv 管理的 Python。构建完成后在容器终端运行 `check-env` 验收公共环境、语言工具链和宿主机接入状态。完整执行路线见 [Linux 容器 setup](../setups/container/README.md)，设计与限制见 [容器环境文档](../docs/containers/README.md)。
