FROM alpine:3.11

ENV DANTE_VER 1.4.2
ENV DANTE_URL https://www.inet.no/dante/files/dante-$DANTE_VER.tar.gz
ENV DANTE_SHA 4c97cff23e5c9b00ca1ec8a95ab22972813921d7fbf60fc453e3e06382fc38a7

RUN apk add --no-cache --virtual .build-deps \
        build-base \
        curl \
        linux-pam-dev && \
    install -v -d /src && \
    curl -sSL $DANTE_URL -o /src/dante.tar.gz && \
    echo "$DANTE_SHA */src/dante.tar.gz" | sha256sum -c && \
    tar -C /src -vxzf /src/dante.tar.gz && \
    cd /src/dante-$DANTE_VER && \
    # https://lists.alpinelinux.org/alpine-devel/3932.html
    ac_cv_func_sched_setscheduler=no ./configure && \
    make -j install && \
    cd / && rm -r /src && \
    apk del .build-deps && \
    apk add --no-cache \
        linux-pam

RUN apk add openvpn

RUN apk add --no-cache supervisor

RUN apk update \
    && apk add openssh \
    && mkdir /root/.ssh \
    && chmod 0700 /root/.ssh \
    && ssh-keygen -A \
    && sed -i s/^#PasswordAuthentication\ yes/PasswordAuthentication\ yes/ /etc/ssh/sshd_config \
    && sed -i s/^#PermitRootLogin\ prohibit-password/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
    && sed -i s/^AllowTcpForwarding\ no/AllowTcpForwarding\ yes/ /etc/ssh/sshd_config \
    && echo -e "test\ntest\n" | passwd root

RUN apk add squid

COPY supervisord.conf /etc/supervisord.conf
COPY sockd.conf /etc/

EXPOSE 1080

USER root
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]