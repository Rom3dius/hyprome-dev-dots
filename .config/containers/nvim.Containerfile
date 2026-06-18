FROM registry.fedoraproject.org/fedora:latest

RUN dnf -y install \
    neovim \
    git \
    ripgrep \
    fd-find \
    fzf \
    nodejs \
    npm \
    podman \
    curl \
    unzip \
    make \
    gcc \
    python3 \
    python3-pip \
    && dnf clean all && rm -rf /var/cache/dnf
