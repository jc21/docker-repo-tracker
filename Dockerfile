FROM alpine:3.5

RUN echo "fs.file-max = 65535" > /etc/sysctl.conf
RUN apk update && apk upgrade \
    && apk add --no-cache bash openssh curl git \
    && rm -rf /var/cache/apk/*

RUN echo "/bin/bash" >> /etc/shells \
    && sed -i -- 's/bin\/ash/bin\/bash/g' /etc/passwd

ADD env/.bashrc /root/
ADD env/.ssh/config /root/.ssh/config

COPY rootfs /

CMD ["/usr/bin/check.sh"]
