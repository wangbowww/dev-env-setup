#!/usr/bin/env bash
set -euo pipefail

DOTFILES_REF="${1:?dotfiles commit is required}"
PYTHON_VERSION="${2:?Python version is required}"
DOTFILES_DIR="/tmp/personal-dotfiles"

export HOME=/root

apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  curl \
  git \
  less \
  openssh-client \
  vim \
  zsh
rm -rf /var/lib/apt/lists/*

mkdir -p \
  "$HOME/.ssh" \
  "$HOME/Codes" \
  "$HOME/Toolchains/uv/bin" \
  "$HOME/Toolchains/uv/cache/python" \
  "$HOME/Toolchains/uv/credentials" \
  "$HOME/Toolchains/uv/python" \
  "$HOME/Toolchains/uv/tools"
chmod 700 "$HOME/Toolchains/uv/credentials"
chmod 700 "$HOME/.ssh"

git init "$DOTFILES_DIR"
git -C "$DOTFILES_DIR" remote add origin \
  https://github.com/wangbowww/dotfiles.git
git -C "$DOTFILES_DIR" fetch --depth=1 origin "$DOTFILES_REF"
git -C "$DOTFILES_DIR" checkout --detach FETCH_HEAD

bash "$DOTFILES_DIR/install-zsh.sh"
bash "$DOTFILES_DIR/install-vim.sh"

cat >> "$HOME/.zshrc.local" <<'EOF'

# personal-dev-setup: uv managed storage
export UV_CACHE_DIR="$HOME/Toolchains/uv/cache"
export UV_PYTHON_CACHE_DIR="$HOME/Toolchains/uv/cache/python"
export UV_CREDENTIALS_DIR="$HOME/Toolchains/uv/credentials"
export UV_PYTHON_INSTALL_DIR="$HOME/Toolchains/uv/python"
export UV_PYTHON_BIN_DIR="$HOME/Toolchains/uv/bin"
export UV_TOOL_DIR="$HOME/Toolchains/uv/tools"
export UV_TOOL_BIN_DIR="$HOME/Toolchains/uv/bin"
export UV_MANAGED_PYTHON=1
export UV_NO_MODIFY_PATH=1
export PATH="$HOME/Toolchains/uv/bin:$PATH"
EOF
chmod 600 "$HOME/.zshrc.local"

curl -LsSf https://astral.sh/uv/install.sh | \
  env UV_INSTALL_DIR="$UV_INSTALL_DIR" UV_NO_MODIFY_PATH=1 sh

uv python install "$PYTHON_VERSION"
chsh -s "$(command -v zsh)" root

git -C "$DOTFILES_DIR" rev-parse HEAD | grep -Fx "$DOTFILES_REF"
uv python find "$PYTHON_VERSION"
zsh -n "$HOME/.zshrc"
vim -Nu "$HOME/.vimrc" -n -es -c 'qall' </dev/null

rm -rf "$DOTFILES_DIR"
