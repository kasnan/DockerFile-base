FROM ubuntu:20.04
MAINTAINER Kimsajang <kasnanganji@gmail.com>


ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Seoul


# RUN 의미 : 여기에 해당되는 코드를 실행하라!
# RUN apt-get ~~~ : apt-get을 실행하라!
# -y를 넣지 않으면 자동 설치가 진행되지 않습니다.
RUN apt-get -y update &&\
 apt-get install -y git wget zsh tzdata vim sudo ufw curl

# 기본 쉘을 bash에서 zsh로 변환
RUN chsh -s /bin/zsh
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 폰트를 바꿔주는 부분이라 여긴 안해도 됩니다.
RUN apt-get -y install fonts-powerline

# zsh-autosuggestions, zsh-syntax-highlighting을 플러그인에 추가하는 코드
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# Perl이란? : https://happygrammer.github.io/guide/perl/
# 펄을 활용하면 vi ~/.zshrc를 해서 직접 수정해야하는 부분이 자동화가 가능하다!! 
RUN perl -pi -w -e 's/ZSH_THEME=.*/ZSH_THEME="agnoster"/g;' ~/.zshrc 
RUN perl -pi -w -e 's/plugins=.*/plugins=(git ssh-agent zsh-autosuggestions zsh-syntax-highlighting)/g;' ~/.zshrc

RUN adduser --disabled-password --gecos "" user  \
    && echo 'user:user' | chpasswd \
    && adduser user sudo \
    && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# 경우에 따라 시간대가 안맞는 에러가 발생해서, 이 코드는 웬만하면 넣는게 좋습니다. 
RUN sudo apt-get install -y language-pack-en && sudo update-locale

# 설치로 생성된 캐시 파일들을 삭제해서 용량 줄이기!
RUN apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/cache/* && \
    rm -rf /var/lib/log/*


# EXPOSE : 해당 포트 번호를 외부에 노출한다.
# ssh의 기본 포트 번호는 22, mysql은 3306입니다. 
# 이 포트를 열지 않는다면 우분투가 정상적으로 설치되더라도 외부와 통신을 할 수 없습니다.
EXPOSE 22 3306

CMD ["zsh"]