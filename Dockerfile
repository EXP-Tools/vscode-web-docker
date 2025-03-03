# 最新版 4.97.2 默认引入了 Copilot ，但是有个 BUG 无法打开工作区
# https://github.com/coder/code-server/issues/7214
FROM linuxserver/code-server:4.96.4

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean && \
    apt-get update -y && \
    apt-get install -y zsh git-core && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/abc/
# RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /opt/.oh-my-zsh
ADD ./volumes/ohmyzsh/20250226  /opt/.oh-my-zsh
RUN chsh -s /bin/zsh
ADD ./volumes/ohmyzsh/config/.zshrc /root/.zshrc

RUN echo "alias ll='ls -alF'" >> /root/.bashrc
EXPOSE 8443
WORKDIR /config/
