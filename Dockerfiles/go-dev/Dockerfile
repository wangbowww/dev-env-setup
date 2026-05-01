FROM mcr.microsoft.com/devcontainers/go:1-bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV GOPATH=/go
ENV PATH="${GOPATH}/bin:${PATH}"

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

RUN echo "parse_git_branch() { git branch --show-current 2>/dev/null; }" >> /root/.bashrc && \
    echo "export PS1='\[\033[1;36m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]\$(git_branch=\$(parse_git_branch); if [ -n \"\$git_branch\" ]; then echo \" \[\033[1;33m\](\$git_branch)\[\033[0m\]\"; fi)\n\[\033[1;32m\]\\$\[\033[0m\] '" >> /root/.bashrc

WORKDIR /root/Codes
