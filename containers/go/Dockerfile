FROM mcr.microsoft.com/devcontainers/go:1.26-bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH=/go \
    UV_INSTALL_DIR=/root/Toolchains/uv/bin \
    UV_CACHE_DIR=/root/Toolchains/uv/cache \
    UV_PYTHON_CACHE_DIR=/root/Toolchains/uv/cache/python \
    UV_CREDENTIALS_DIR=/root/Toolchains/uv/credentials \
    UV_PYTHON_INSTALL_DIR=/root/Toolchains/uv/python \
    UV_PYTHON_BIN_DIR=/root/Toolchains/uv/bin \
    UV_TOOL_DIR=/root/Toolchains/uv/tools \
    UV_TOOL_BIN_DIR=/root/Toolchains/uv/bin \
    UV_MANAGED_PYTHON=1 \
    UV_NO_MODIFY_PATH=1 \
    PERSONAL_DEV_PROFILE=go \
    PATH=/root/Toolchains/uv/bin:/go/bin:${PATH}

ARG DOTFILES_REF=6c96fde573093fa670ecb74e0ab298caef208188
ARG PYTHON_VERSION=3.13

COPY containers/common/install-linux-setup.sh /tmp/install-linux-setup.sh
COPY containers/common/check-environment.sh /usr/local/bin/check-env
RUN bash /tmp/install-linux-setup.sh "$DOTFILES_REF" "$PYTHON_VERSION" && \
    rm /tmp/install-linux-setup.sh && \
    chmod 755 /usr/local/bin/check-env

# Additional Go development tools and RPC support.
RUN apt-get update && apt-get install -y \
    protobuf-compiler \
    make \
    jq \
    tree \
    htop \
    && rm -rf /var/lib/apt/lists/*

RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install honnef.co/go/tools/cmd/staticcheck@latest && \
    go install mvdan.cc/gofumpt@latest && \
    go install golang.org/x/vuln/cmd/govulncheck@latest && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest && \
    go clean -cache -modcache

WORKDIR /root/Codes
