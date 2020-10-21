# How to use :
# docker build -t expm02/docker-nginx --build-arg domain=demo_domain.com .
# --------------------------------------------------------------------------------

FROM linuxserver/code-server:latest
MAINTAINER EXP

RUN sed -i s@/deb.debian.org/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean && \
    apt-get update -y && \
    apt-get install -y zsh git-core && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh && \
    cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && \
    chsh -s /bin/zsh


EXPOSE 8443
WORKDIR /config/
