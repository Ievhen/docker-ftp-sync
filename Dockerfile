FROM ubuntu:latest

RUN apt-get update \
    && apt-get upgrade -y \
    && apt install passwd \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
    && apt-get install -y vsftpd openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./config/vsftpd.conf.template /etc/vsftpd.conf.template
COPY ./scripts/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 21
EXPOSE 30000-30009

ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "/usr/sbin/vsftpd", "/etc/vsftpd.conf" ]
