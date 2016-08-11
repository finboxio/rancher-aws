FROM alpine:3.4

ENV CONVOY_VERSION 0.5.0-rc1
RUN apk add --no-cache curl bash jq \
    && curl https://raw.githubusercontent.com/mvertes/dosu/0.1.0/dosu -o /sbin/dosu \
    && chmod +x /sbin/dosu \
    && echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
    && apk add --no-cache mongodb python py-pip \
    && pip install awscli \
    && curl -L https://github.com/rancher/convoy/releases/download/v${CONVOY_VERSION}/convoy.tar.gz -o convoy.tar.gz \
    && tar -xzf convoy.tar.gz \
    && cp convoy/convoy convoy/convoy-pdata_tools /usr/bin/ \
    && rm -rf convoy.tar.gz convoy \
    && apk del curl py-pip

RUN mkdir -p /etc/mongo

ADD mongo-* /usr/bin/
RUN chmod +x /usr/bin/mongo-*

ENTRYPOINT /usr/bin/mongo-bootstrap
