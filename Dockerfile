FROM debian:stable-slim

RUN apt update && \
    apt upgrade -y && \
    apt install -y jq curl gpg wget sshpass openssh-client && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg |apt-key add -  > /dev/null 2>&1 && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list > /dev/null && \
    apt update && \
    apt install -y kubectl  && \
    # Hard cleanning
    apt-get clean autoclean && \
    apt-get autoremove --yes  && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ 

COPY --chmod=755 build/kc.sh build/klb.sh build/kw.sh build/km.sh /usr/bin
ENTRYPOINT ["/usr/bin/kc.sh"]


