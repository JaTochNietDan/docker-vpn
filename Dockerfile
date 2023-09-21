FROM debian:bullseye

RUN apt-get update

RUN apt-get install -y openvpn
RUN apt-get install -y supervisor
RUN apt-get install -y ssh

RUN apt install -y \
    dante-server \
    openssl \
    curl

RUN mkdir /root/.ssh \
    && chmod 0700 /root/.ssh \
    && ssh-keygen -A \
    && sed -i s/^#PasswordAuthentication\ yes/PasswordAuthentication\ yes/ /etc/ssh/sshd_config \
    && sed -i s/^#PermitRootLogin\ prohibit-password/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
    && sed -i s/^AllowTcpForwarding\ no/AllowTcpForwarding\ yes/ /etc/ssh/sshd_config \
    && echo "root:test"|chpasswd

RUN apt-get install -y squid
RUN apt-get install -y curl

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.16/bin/linux/arm64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# Allow all connections via squid
RUN sed -i '/^http_access deny all/i acl all src 0.0.0.0/0\nhttp_access allow all' /etc/squid/squid.conf 
RUN sed -i '/^http_access deny CONNECT !SSL_ports/d' /etc/squid/squid.conf 
RUN sed -i '/^http_access deny !Safe_ports/d' /etc/squid/squid.conf

COPY supervisord.conf /etc/supervisord.conf
COPY sockd.conf /etc/danted.conf
COPY up.sh /home/up.sh
RUN chmod +x /home/up.sh

RUN mkdir /var/run/sshd

EXPOSE 1080

USER root
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]