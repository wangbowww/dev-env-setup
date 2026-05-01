FROM keepalivewww/pytorch-dev:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV CONDA_DIR=/opt/conda
ENV PATH="${CONDA_DIR}/bin:${PATH}"

# Linux development tools
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    htop \
    build-essential \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Python environment manager tooling
# already have conda installed in the base image

RUN echo "parse_git_branch() { git branch --show-current 2>/dev/null; }" >> /root/.bashrc && \
    echo "source ${CONDA_DIR}/etc/profile.d/conda.sh" >> /root/.bashrc && \
    echo "export PS1='\[\033[1;36m\]\u@\h\[\033[0m\]:\[\033[1;34m\]\w\[\033[0m\]\$(git_branch=\$(parse_git_branch); if [ -n \"\$git_branch\" ]; then echo \" \[\033[1;33m\](\$git_branch)\[\033[0m\]\"; fi)\n\[\033[1;32m\]\\$\[\033[0m\] '" >> /root/.bashrc
WORKDIR /root/Codes
