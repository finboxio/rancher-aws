FROM alpine:3.4

ENV CONVOY_VERSION 0.5.0-rc1
RUN apk add --no-cache curl e2fsprogs jq python py-pip \
    && ln -s /sbin/mkfs.ext4 /sbin/mkfs \
    && pip install awscli \
    && curl -L https://github.com/frol/docker-alpine-env/raw/master/bin/nsenter -o /bin/nsenter \
    && chmod +x /bin/nsenter \
    && curl -L https://github.com/rancher/convoy/releases/download/v${CONVOY_VERSION}/convoy.tar.gz -o convoy.tar.gz \
    && tar -xzf convoy.tar.gz \
    && cp convoy/convoy convoy/convoy-pdata_tools /usr/bin/ \
    && rm -rf convoy.tar.gz convoy \
    && apk del curl py-pip

VOLUME /var/lib/rancher/convoy

ADD convoy-mount /usr/bin/convoy-mount
ADD convoy-bootstrap /usr/bin/convoy-bootstrap

ENTRYPOINT /usr/bin/convoy-bootstrap
