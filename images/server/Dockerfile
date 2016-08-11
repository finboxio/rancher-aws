FROM debian:jessie

# common installation
#   - aws, curl, unzip, nano, jq, software-properties-common, git, xinetd
RUN apt-get clean && apt-get update \
    && apt-get install -y python python-pip curl unzip nano git software-properties-common xinetd \
    && curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/bin/jq \
    && chmod +x /usr/bin/jq \
    && pip install awscli

# mysql/galera installation
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db \
    && add-apt-repository 'deb [arch=amd64,i386] http://mirror.jmu.edu/pub/mariadb/repo/10.1/debian jessie main' \
    && apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y mariadb-server mariadb-client rsync galera-3 \
    && chown -R mysql:mysql /usr/bin/mysql*

# ec2 snapshot installation
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get install -y libxml-sax-expat-incremental-perl \
    && git clone https://github.com/alestic/ec2-consistent-snapshot \
    && mv ec2-consistent-snapshot/ec2-consistent-snapshot /usr/bin/ \
    && rm -rf ec2-consistent-snapshot \
    && PERL_MM_USE_DEFAULT=1 cpan File::Slurp \
    && PERL_MM_USE_DEFAULT=1 cpan IO::Socket::SSL \
    && PERL_MM_USE_DEFAULT=1 cpan Net::Amazon::EC2 \
    && PERL_MM_USE_DEFAULT=1 cpan DateTime::Locale \
    && PERL_MM_USE_DEFAULT=1 cpan DateTime::TimeZone

# haproxy installation
ENV HAPROXY_MAJOR 1.6
ENV HAPROXY_VERSION 1.6.7
ENV HAPROXY_MD5 a046ed63b00347bd367b983529dd541f
RUN buildDeps='gcc libc6-dev libpcre3-dev libssl-dev make' \
    && set -x \
    && apt-get update && apt-get install -y $buildDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    && curl -SL "http://www.haproxy.org/download/${HAPROXY_MAJOR}/src/haproxy-${HAPROXY_VERSION}.tar.gz" -o haproxy.tar.gz \
    && echo "${HAPROXY_MD5}  haproxy.tar.gz" | md5sum -c \
    && mkdir -p /usr/src/haproxy \
    && tar -xzf haproxy.tar.gz -C /usr/src/haproxy --strip-components=1 \
    && rm haproxy.tar.gz \
    && make -C /usr/src/haproxy \
        TARGET=linux2628 \
        USE_PCRE=1 PCREDIR= \
        USE_OPENSSL=1 \
        USE_ZLIB=1 \
        all \
        install-bin \
    && mkdir -p /usr/local/etc/haproxy \
    && cp -R /usr/src/haproxy/examples/errorfiles /usr/local/etc/haproxy/errors \
    && rm -rf /usr/src/haproxy \
    && apt-get purge -y --auto-remove $buildDeps

# serf installation
ENV SERF_VERSION 0.7.0
RUN curl -L https://releases.hashicorp.com/serf/${SERF_VERSION}/serf_${SERF_VERSION}_linux_amd64.zip -o serf-v${SERF_VERSION}-linux-amd64.zip \
    && unzip serf-v${SERF_VERSION}-linux-amd64.zip \
    && rm serf-v${SERF_VERSION}-linux-amd64.zip \
    && mv serf /usr/bin/

# convoy installation
ENV CONVOY_VERSION 0.5.0-rc1
RUN curl -L https://github.com/rancher/convoy/releases/download/v${CONVOY_VERSION}/convoy.tar.gz -o convoy.tar.gz \
    && tar -xzf convoy.tar.gz \
    && cp convoy/convoy convoy/convoy-pdata_tools /usr/bin/ \
    && rm -rf convoy.tar.gz convoy

# gotpl && checkup installation
ENV GO_VERSION 1.6.3
ENV CHECKUP_VERSION 6c6ae13e5576edcf386aaf2c99b2b7537b95d84f
RUN set -x \
    && curl -SL "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" -o go.tar.gz \
    && mkdir -p /usr/local/go /usr/src/go \
    && tar -xzf go.tar.gz -C /usr/local/go --strip-components=1 \
    && export GOPATH=/usr/src/go \
    && /usr/local/go/bin/go get github.com/tsg/gotpl \
    && mv /usr/src/go/bin/gotpl /usr/bin/gotpl \
    && /usr/local/go/bin/go get github.com/finboxio/checkup \
    && /usr/local/go/bin/go get github.com/spf13/cobra \
    && cd $GOPATH/src/github.com/finboxio/checkup \
    && /usr/local/go/bin/go build -o checkup cmd/checkup/main.go \
    && mv checkup /usr/bin/checkup \
    && rm -rf go.tar.gz /usr/local/go /usr/src/go

# rsyslog installation
RUN apt-get install -y rsyslog
RUN mkdir -p /etc/rsyslog.d

ADD . /var/lib/aws
RUN cp /var/lib/aws/slack/slack /usr/bin/slack \
    && mkdir -p /usr/local/etc/haproxy/ \
    && cp /var/lib/aws/haproxy/haproxy-conf /usr/bin/ \
    && cp /var/lib/aws/haproxy/haproxy-bootstrap /usr/bin/ \
    && cp /var/lib/aws/haproxy/haproxy.cfg.tmpl /usr/local/etc/haproxy/ \
    && cp /var/lib/aws/haproxy/rsyslog.conf /etc/rsyslog.conf \
    && mkdir -p /etc/serf \
    && cp /var/lib/aws/serf/serf-bootstrap /usr/bin/ \
    && cp /var/lib/aws/mysql/my.cnf /etc/mysql/ \
    && mkdir -p /etc/mysql/data && chown -R mysql:mysql /etc/mysql/data \
    && cp /var/lib/aws/mysql/mysql-bootstrap /usr/bin/mysql-bootstrap \
    && cp /var/lib/aws/mysql/mysql-volume /usr/bin/mysql-volume \
    && cp /var/lib/aws/mysql/mysql-backup /usr/bin/mysql-backup \
    && cp /var/lib/aws/mysql/mysql-monitor /usr/bin/mysql-monitor \
    && chown -R mysql:mysql /usr/bin/mysql-* \
    && mkdir -p /etc/mysqlcheck \
    && cp /var/lib/aws/mysqlcheck/mysqlcheck /usr/bin/mysqlcheck \
    && cp /var/lib/aws/mysqlcheck/mysqlcheck-bootstrap /usr/bin/mysqlcheck-bootstrap \
    && cp /var/lib/aws/mysqlcheck/service /etc/mysqlcheck/service \
    && chown -R mysql:mysql /usr/bin/mysqlcheck* \
    && mkdir -p /etc/terminator \
    && cp /var/lib/aws/terminator/terminator /usr/bin/terminator \
    && cp /var/lib/aws/terminator/terminator-bootstrap /usr/bin/terminator-bootstrap \
    && cp /var/lib/aws/terminator/service /etc/terminator/service \
    && cp /var/lib/aws/rancher/rancher-bootstrap /usr/bin/rancher-bootstrap \
    && cp /var/lib/aws/convoy/convoy-bootstrap /usr/bin/convoy-bootstrap \
    && cp /var/lib/aws/shudder/shudder /usr/bin/shudder \
    && cp /var/lib/aws/reporter/reporter /usr/bin/reporter \
    && cp /var/lib/aws/docker-monitor/docker-monitor /usr/bin/docker-monitor \
    && cp /var/lib/aws/backup/backup /usr/bin/backup \
    && cp /var/lib/aws/tag-sync/tag-sync /usr/bin/tag-sync \
    && mkdir -p /etc/healthcheck \
    && cp /var/lib/aws/healthcheck/healthcheck /usr/bin/healthcheck \
    && cp /var/lib/aws/healthcheck/healthcheck-bootstrap /usr/bin/healthcheck-bootstrap \
    && cp /var/lib/aws/healthcheck/service /etc/healthcheck/service \
    && cp /var/lib/aws/cluster-monitor/cluster-monitor /usr/bin/cluster-monitor \
    && cp /var/lib/aws/fleet-monitor/fleet-monitor /usr/bin/fleet-monitor
