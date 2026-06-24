FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color
ENV COLORTERM=truecolor

# Bootstrap: minimum needed for install scripts to run
RUN apt-get update && apt-get install -y \
    sudo \
    git \
    curl \
    unzip \
    make \
    software-properties-common \
    && add-apt-repository universe \
    && rm -rf /var/lib/apt/lists/*

# Non-root user (install scripts use sudo)
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER testuser
WORKDIR /home/testuser/dotfiles

COPY --chown=testuser:testuser . .

# Full install — same as `make install` on a fresh machine
RUN make install

CMD ["bash"]
