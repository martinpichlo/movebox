FROM alpine:latest
MAINTAINER Martin Pichlo <m.pichlo@gmx.de>
ADD entrypoint.sh /usr/local/bin

RUN apk add --update inotify-tools && \
    rm -rf /tmp/* /var/cache/apk/* && \
    cat > /etc/motd && \
    mkdir /mnt/inbox /mnt/outbox

ENTRYPOINT ["entrypoint.sh"]
