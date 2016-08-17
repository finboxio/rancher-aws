FROM alpine:3.4

ENV CONVOY_VERSION 0.5.0-rc1
RUN echo http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
    && apk add --no-cache curl bash mongodb python py-pip util-linux coreutils \
    && curl https://raw.githubusercontent.com/mvertes/dosu/0.1.0/dosu -o /sbin/dosu \
    && chmod +x /sbin/dosu \
    && curl -L -o /usr/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 \
    && chmod +x /usr/bin/jq \
    && pip install awscli \
    && curl -L https://github.com/rancher/convoy/releases/download/v${CONVOY_VERSION}/convoy.tar.gz -o convoy.tar.gz \
    && tar -xzf convoy.tar.gz \
    && cp convoy/convoy convoy/convoy-pdata_tools /usr/bin/ \
    && rm -rf convoy.tar.gz convoy \
    && apk del py-pip

RUN mkdir -p /etc/mongo

ADD mongo-* /usr/bin/
RUN chmod +x /usr/bin/mongo-*

RUN curl -L -o /usr/bin/slack https://gist.githubusercontent.com/bdentino/6f6f91960e239e158f84d6bfe08cfd1d/raw/d1a387c6c568cff1f5169e158a3dfc15bdd1a9b7/slack-bash
RUN chmod +x /usr/bin/slack

ENTRYPOINT /usr/bin/mongo-bootstrap
