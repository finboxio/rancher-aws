FROM alpine:3.4

RUN apk add --no-cache curl python py-pip jq bash coreutils \
    && pip install awscli \
    && apk del --purge py-pip

# serf installation
ENV SERF_VERSION 0.7.0
ENV SERF_CHECKSUM b239fdcd1c15fd926ff0cd10bc32a31330d1c74aba9e4d49ff83d5707ef1ba4b
RUN curl -L https://releases.hashicorp.com/serf/${SERF_VERSION}/serf_${SERF_VERSION}_linux_amd64.zip -o serf.zip \
    && test "$(sha256sum serf.zip | awk '{ print $1 }')" == "${SERF_CHECKSUM}" \
    && unzip serf.zip \
    && rm serf.zip \
    && mv serf /usr/bin/

# xinetd installation
ENV XINETD_VERSION 2.3.15
COPY xinetd/xinetd.conf /etc/xinetd.conf
RUN curl -L ftp://anduin.linuxfromscratch.org/BLFS/xinetd/xinetd-${XINETD_VERSION}.tar.gz -o xinetd-${XINETD_VERSION}.tar.gz \
    && echo "@edge http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache alpine-sdk libtirpc-dev@edge \
    && tar xvf xinetd-${XINETD_VERSION}.tar.gz \
    && cd xinetd-${XINETD_VERSION} \
    && sed -i -e "s/exec_server/child_process/" xinetd/builtins.c \
    && sed -i -e "/register unsigned count/s/register//" xinetd/itox.c \
    && CFLAGS="-I/usr/include/tirpc -L/usr/lib -ltirpc" ./configure --prefix=/usr --mandir=/usr/share/man --with-loadavg \
    && sed -i -e "/#define rlim_t long long/d" libs/include/config.h \
    && CFLAGS="-I/usr/include/tirpc -L/usr/lib -ltirpc" make \
    && make install \
    && apk del --purge alpine-sdk libtirpc-dev \
    && apk add --no-cache libtirpc \
    && cd .. \
    && rm -rf xinetd${XINETD_VERSION}

ADD . /var/lib/aws
RUN cp /var/lib/aws/slack/slack /usr/bin/slack \
    && cp /var/lib/aws/tag/tag-instance /usr/bin/tag-instance \
    && cp /var/lib/aws/serf/serf-bootstrap /usr/bin/serf-bootstrap \
    && cp /var/lib/aws/shudder/shudder-bootstrap /usr/bin/shudder-bootstrap \
    && cp /var/lib/aws/rancher/rancher-bootstrap /usr/bin/rancher-bootstrap \
    && mkdir -p /etc/terminator \
    && cp /var/lib/aws/terminator/terminator /usr/bin/terminator \
    && cp /var/lib/aws/terminator/terminator-bootstrap /usr/bin/terminator-bootstrap \
    && cp /var/lib/aws/terminator/service /etc/terminator/service \
    && mkdir -p /etc/healthcheck \
    && cp /var/lib/aws/healthcheck/healthcheck /usr/bin/healthcheck \
    && cp /var/lib/aws/healthcheck/healthcheck-bootstrap /usr/bin/healthcheck-bootstrap \
    && cp /var/lib/aws/healthcheck/service /etc/healthcheck/service \
    && cp /var/lib/aws/docker-monitor/docker-monitor /usr/bin/docker-monitor
