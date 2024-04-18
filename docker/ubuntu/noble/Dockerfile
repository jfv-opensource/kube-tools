FROM ubuntu:noble

COPY build/kc.sh build/klb.sh build/kw.sh build/km.sh /usr/bin/

RUN mkdir -p /etc/apt/keyrings && \
    apt update && \
    apt upgrade -y && \
    apt install -y jq curl gpg wget sshpass openssh-client && \
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | tee /etc/apt/sources.list.d/kubernetes.list && \
    chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg && \
    chmod 644 /etc/apt/sources.list.d/kubernetes.list && \
    apt update && \
    apt install -y kubectl  && \
    # Hard cleanning
    apt-get clean autoclean && \
    apt-get autoremove --yes  && \
    rm -rf /var/lib/{apt,dpkg,cache,log}/ && \
    chmod 755 /usr/bin/kc.sh  /usr/bin/km.sh /usr/bin/kw.sh /usr/bin/klb.sh


ENTRYPOINT ["/usr/bin/kc.sh"]


