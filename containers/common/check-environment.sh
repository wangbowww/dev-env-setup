#!/usr/bin/env bash
set -u

PROFILE="${PERSONAL_DEV_PROFILE:-unknown}"
FAILURES=0
WARNINGS=0

pass() {
  printf '[PASS] %s\n' "$1"
}

fail() {
  printf '[FAIL] %s\n' "$1"
  FAILURES=$((FAILURES + 1))
}

warn() {
  printf '[WARN] %s\n' "$1"
  WARNINGS=$((WARNINGS + 1))
}

check_command() {
  local command_name="$1"

  if command -v "$command_name" >/dev/null 2>&1; then
    pass "command: $command_name"
  else
    fail "missing command: $command_name"
  fi
}

check_file() {
  local path="$1"

  if [[ -f "$path" ]]; then
    pass "file: $path"
  else
    fail "missing file: $path"
  fi
}

check_directory() {
  local path="$1"

  if [[ -d "$path" ]]; then
    pass "directory: $path"
  else
    fail "missing directory: $path"
  fi
}

check_environment_value() {
  local variable_name="$1"
  local expected_value="$2"
  local actual_value="${!variable_name:-}"

  if [[ "$actual_value" == "$expected_value" ]]; then
    pass "$variable_name=$expected_value"
  else
    fail "$variable_name expected '$expected_value', got '${actual_value:-<unset>}'"
  fi
}

check_extension() {
  local extension_id="$1"

  if grep -Fxiq "$extension_id" <<<"$INSTALLED_EXTENSIONS"; then
    pass "VS Code extension: $extension_id"
  else
    fail "missing VS Code extension: $extension_id"
  fi
}

printf 'Personal development container check\n'
printf 'Profile: %s\n\n' "$PROFILE"

if [[ "$(uname -s)" == "Linux" ]]; then
  pass 'container OS: Linux'
else
  fail "container OS is not Linux: $(uname -s)"
fi

for command_name in git ssh zsh vim uv; do
  check_command "$command_name"
done

check_directory "$HOME/Codes"
check_directory "$HOME/Toolchains/uv"
check_directory "$HOME/Toolchains/uv/cache/python"
check_directory "$HOME/Toolchains/uv/credentials"
check_directory "$HOME/Toolchains/uv/python"
check_directory "$HOME/Toolchains/uv/tools"

check_file "$HOME/.zshrc"
check_file "$HOME/.vimrc"
check_file "$HOME/.zshrc.local"
check_directory "$HOME/.oh-my-zsh"
check_directory "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
check_directory "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"

check_environment_value UV_CACHE_DIR "$HOME/Toolchains/uv/cache"
check_environment_value UV_PYTHON_CACHE_DIR "$HOME/Toolchains/uv/cache/python"
check_environment_value UV_CREDENTIALS_DIR "$HOME/Toolchains/uv/credentials"
check_environment_value UV_PYTHON_INSTALL_DIR "$HOME/Toolchains/uv/python"
check_environment_value UV_PYTHON_BIN_DIR "$HOME/Toolchains/uv/bin"
check_environment_value UV_TOOL_DIR "$HOME/Toolchains/uv/tools"
check_environment_value UV_TOOL_BIN_DIR "$HOME/Toolchains/uv/bin"
check_environment_value UV_MANAGED_PYTHON 1

if uv python find >/dev/null 2>&1; then
  pass "uv-managed Python: $(uv python find 2>/dev/null)"
else
  fail 'uv cannot find a managed Python installation'
fi

case "$PROFILE" in
  cpp)
    for command_name in cc c++ cmake make gdb; do
      check_command "$command_name"
    done
    ;;
  go)
    for command_name in go gopls dlv staticcheck gofumpt govulncheck \
      protoc protoc-gen-go protoc-gen-go-grpc; do
      check_command "$command_name"
    done
    ;;
  pytorch)
    check_command python
    if python -c \
      'import torch; assert torch.__version__.split("+")[0] == "2.8.0"' \
      >/dev/null 2>&1; then
      pass 'PyTorch version: 2.8.0'
    else
      fail 'PyTorch 2.8.0 is not importable from the base Python'
    fi

    if python -c \
      'import torch; assert torch.version.cuda == "12.8"' \
      >/dev/null 2>&1; then
      pass 'PyTorch CUDA build: 12.8'
    else
      fail 'PyTorch is not built for CUDA 12.8'
    fi

    if python -c \
      'import torch; raise SystemExit(0 if torch.cuda.is_available() else 1)' \
      >/dev/null 2>&1; then
      pass 'NVIDIA GPU is available to PyTorch'
    else
      warn 'PyTorch image is ready, but no NVIDIA GPU is available at runtime'
    fi
    ;;
  *)
    fail "unknown PERSONAL_DEV_PROFILE: $PROFILE"
    ;;
esac

printf '\nRuntime integration\n'

if [[ -f "$HOME/.ssh/github-key.pub" ]]; then
  pass 'GitHub signing public key is mounted'
else
  warn 'GitHub signing public key is not mounted'
fi

if git config --global --get user.name >/dev/null 2>&1; then
  pass 'Git user.name is available'
else
  warn 'Git user.name was not inherited from the host'
fi

if git config --global --get user.email >/dev/null 2>&1; then
  pass 'Git user.email is available'
else
  warn 'Git user.email was not inherited from the host'
fi

if [[ "$(git config --global --get gpg.format 2>/dev/null || true)" == "ssh" ]]; then
  pass 'Git signing format: ssh'
else
  warn 'Git signing format is not ssh'
fi

if [[ "$(git config --global --get user.signingkey 2>/dev/null || true)" == \
  "$HOME/.ssh/github-key.pub" ]]; then
  pass 'Git signing key points to the mounted public key'
else
  warn 'Git signing key does not point to the mounted public key'
fi

if [[ -n "${SSH_AUTH_SOCK:-}" ]] && ssh-add -l >/dev/null 2>&1; then
  pass 'SSH agent is forwarded and has at least one identity'
else
  warn 'SSH agent is unavailable or contains no identities'
fi

printf '\nVS Code integration\n'

if command -v code >/dev/null 2>&1 && \
  INSTALLED_EXTENSIONS="$(code --list-extensions 2>/dev/null)" && \
  [[ -n "$INSTALLED_EXTENSIONS" ]]; then
  case "$PROFILE" in
    cpp)
      check_extension ms-vscode.cpptools
      ;;
    go)
      check_extension golang.go
      ;;
    pytorch)
      check_extension ms-python.debugpy
      check_extension ms-python.python
      check_extension ms-python.vscode-pylance
      check_extension ms-python.vscode-python-envs
      check_extension ms-toolsai.jupyter
      check_extension ms-toolsai.jupyter-keymap
      ;;
  esac
else
  INSTALLED_EXTENSIONS=''
  warn 'VS Code CLI is unavailable; reconnect with Dev Containers and rerun check-env'
fi

printf '\nSummary: %d failure(s), %d warning(s)\n' "$FAILURES" "$WARNINGS"

if ((FAILURES > 0)); then
  exit 1
fi

printf 'Environment is ready. Review warnings for host/account integration.\n'
