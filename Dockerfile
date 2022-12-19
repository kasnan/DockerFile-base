FROM ubuntu:20.04
LABEL MAINTAINER kim <kasnanganji@gmail.com>

RUN apt-get update && apt-get install -y sudo git
RUN apt-get -y install zsh
RUN chsh -s /usr/bin/zsh # oh-my-zsh install
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # powerline install
RUN apt-get -y install fonts-powerline # hack font install COPY ttf /ttf ENV TERM xterm-256color # bullet-train theme install
RUN git clone https://github.com/caiogondim/bullet-train.zsh.git ~/.oh-my-zsh/custom/theme/bullet-train ENV ZSH_THEME bullet-train/bullet-train COPY .zshrc /root/.zshrc

CMD ["zsh"]

RUN adduser --disabled-password --gecos "" user  \
    && echo '9847' | chpasswd \
    && adduser user AdminKIM \
    && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


WORKDIR C:/Users/kasna/Documents/