FROM alpine:3.6

ENV HOME=/home/duplicity
WORKDIR /home/duplicity

ENV BUILD_DEPS="" \
    RUNTIME_DEPS="bash mysql-client ca-certificates duplicity lftp openssh openssl rsync"

RUN set -x && \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS && \
    apk del build_deps && \
    update-ca-certificates

RUN set -x && \
    adduser -D -u 1000 duplicity && \
    mkdir -p /home/duplicity/.cache/duplicity && \
    mkdir -p /home/duplicity/.gnupg && \
    su - duplicity -c 'duplicity --version' && \
    chmod -R go+rwx /home/duplicity/ && \
    chmod -R 600 /home/duplicity/.gnupg && \
    chown -R duplicity:duplicity /home/duplicity/

ADD backup.sh /

VOLUME ["/home/duplicity/.cache/duplicity", "/home/duplicity/.gnupg"]

USER duplicity