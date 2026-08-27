FROM pytorch/pytorch:2.8.0-cuda12.8-cudnn9-runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/opt/conda
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
    PERSONAL_DEV_PROFILE=pytorch \
    PATH=/root/Toolchains/uv/bin:/opt/conda/bin:${PATH}

ARG DOTFILES_REF=c51f5edec824176f660456084b348b5807cc69ad
ARG PYTHON_VERSION=3.13

COPY containers/common/install-linux-setup.sh /tmp/install-linux-setup.sh
COPY containers/common/check-environment.sh /usr/local/bin/check-env
RUN bash /tmp/install-linux-setup.sh "$DOTFILES_REF" "$PYTHON_VERSION" && \
    rm /tmp/install-linux-setup.sh && \
    chmod 755 /usr/local/bin/check-env

RUN python -c 'import torch; print(torch.__version__, torch.version.cuda)'

WORKDIR /root/Codes
