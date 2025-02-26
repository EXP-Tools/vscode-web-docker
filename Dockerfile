FROM linuxserver/code-server:4.97.2

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN apt-get clean && \
    apt-get update -y && \
    apt-get install -y zsh git-core && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/abc/
# RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /opt/.oh-my-zsh
ADD ./volumes/ohmyzsh-20250226  /opt/.oh-my-zsh
RUN chsh -s /bin/zsh
ADD ./volumes/config/.zshrc /root/.zshrc
ADD ./volumes/config/.zshrc /home/abc/.zshrc

RUN echo "abc	ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/abc && \
    chmod 440 /etc/sudoers.d/abc

EXPOSE 8443
WORKDIR /config/
