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
    && apt-get install -y mariadb-server mariadb-client rsync galera-3

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

# gotpl installation
ENV GO_VERSION 1.6.3
RUN set -x \
    && curl -SL "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" -o go.tar.gz \
    && mkdir -p /usr/local/go /usr/src/go \
    && tar -xzf go.tar.gz -C /usr/local/go --strip-components=1 \
    && export GOPATH=/usr/src/go \
    && /usr/local/go/bin/go get github.com/tsg/gotpl \
    && mv /usr/src/go/bin/gotpl /usr/bin/gotpl \
    && rm -rf go.tar.gz /usr/local/go /usr/src/go

# rsyslog installation
RUN apt-get install -y rsyslog
RUN mkdir -p /etc/rsyslog.d

COPY common/* /usr/bin/

RUN mkdir -p /usr/local/etc/haproxy/
COPY haproxy/haproxy-conf /usr/bin/
COPY haproxy/haproxy-bootstrap /usr/bin/
COPY haproxy/haproxy.cfg.tmpl /usr/local/etc/haproxy/
COPY haproxy/rsyslog.conf /etc/rsyslog.conf

RUN mkdir -p /etc/serf
COPY serf/serf-bootstrap /usr/bin/
EXPOSE 7946
EXPOSE 7373

COPY mysql/my.cnf /etc/mysql/
RUN mkdir -p /etc/mysql/data && chown -R mysql:mysql /etc/mysql/data
EXPOSE 3306
EXPOSE 4567
EXPOSE 4568
EXPOSE 4444

COPY mysql/mysql-bootstrap /usr/bin/mysql-bootstrap
COPY mysql/mysql-volume /usr/bin/mysql-volume
COPY mysql/mysql-backup /usr/bin/mysql-backup
COPY mysql/mysql-monitor /usr/bin/mysql-monitor
RUN chown -R mysql:mysql /usr/bin/mysql*

RUN mkdir -p /etc/mysqlchk
COPY mysqlchk/mysqlchk /usr/bin/mysqlchk
COPY mysqlchk/mysqlchk-bootstrap /usr/bin/mysqlchk-bootstrap
COPY mysqlchk/service /etc/mysqlchk/service
RUN chown -R mysql:mysql /usr/bin/mysqlchk*
EXPOSE 9200

RUN mkdir -p /etc/terminator
COPY terminator/terminator /usr/bin/terminator
COPY terminator/terminator-bootstrap /usr/bin/terminator-bootstrap
COPY terminator/service /etc/terminator/service
EXPOSE 9999

COPY rancher/rancher-bootstrap /usr/bin/rancher-bootstrap

COPY convoy/convoy-bootstrap /usr/bin/convoy-bootstrap

COPY shudder/shudder-bootstrap /usr/bin/shudder-bootstrap

COPY status/monitor /usr/bin/monitor
COPY status/last-words /usr/bin/last-words

COPY backup/backup /usr/bin/backup
