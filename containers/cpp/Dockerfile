FROM mcr.microsoft.com/devcontainers/cpp:bookworm

ENV DEBIAN_FRONTEND=noninteractive
ENV UV_INSTALL_DIR=/root/Toolchains/uv/bin \
    UV_CACHE_DIR=/root/Toolchains/uv/cache \
    UV_PYTHON_CACHE_DIR=/root/Toolchains/uv/cache/python \
    UV_CREDENTIALS_DIR=/root/Toolchains/uv/credentials \
    UV_PYTHON_INSTALL_DIR=/root/Toolchains/uv/python \
    UV_PYTHON_BIN_DIR=/root/Toolchains/uv/bin \
    UV_TOOL_DIR=/root/Toolchains/uv/tools \
    UV_TOOL_BIN_DIR=/root/Toolchains/uv/bin \
    UV_MANAGED_PYTHON=1 \
    UV_NO_MODIFY_PATH=1 \
    PERSONAL_DEV_PROFILE=cpp \
    PATH=/root/Toolchains/uv/bin:${PATH}

ARG DOTFILES_REF=c51f5edec824176f660456084b348b5807cc69ad
ARG PYTHON_VERSION=3.13

COPY containers/common/install-linux-setup.sh /tmp/install-linux-setup.sh
COPY containers/common/check-environment.sh /usr/local/bin/check-env
RUN bash /tmp/install-linux-setup.sh "$DOTFILES_REF" "$PYTHON_VERSION" && \
    rm /tmp/install-linux-setup.sh && \
    chmod 755 /usr/local/bin/check-env

WORKDIR /root/Codes
