FROM debian:jessie

# Common Installation
RUN apt-get clean && apt-get update && \
    apt-get install -y python python-pip curl unzip && \
    curl -L https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -o /usr/bin/jq && \
    chmod +x /usr/bin/jq && \
    pip install awscli && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/debconf/*-old && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/*

# etcd Installation
ENV ETCD_VERSION=3.0.2
ENV ETCDCTL_API=2
RUN curl -L https://github.com/coreos/etcd/releases/download/v$ETCD_VERSION/etcd-v$ETCD_VERSION-linux-amd64.tar.gz -o etcd-v$ETCD_VERSION-linux-amd64.tar.gz && \
    tar xzvf etcd-v$ETCD_VERSION-linux-amd64.tar.gz && \
    rm etcd-v$ETCD_VERSION-linux-amd64.tar.gz && \
    mv etcd-v$ETCD_VERSION-linux-amd64/etcd /usr/bin/etcd && \
    mv etcd-v$ETCD_VERSION-linux-amd64/etcdctl /usr/bin/etcdctl && \
    rm -rf etcd-v$ETCD_VERSION-linux-amd64

# serf Installation
ENV SERF_VERSION=0.7.0
RUN curl -L https://releases.hashicorp.com/serf/${SERF_VERSION}/serf_${SERF_VERSION}_linux_amd64.zip -o serf-v${SERF_VERSION}-linux-amd64.zip && \
    unzip serf-v${SERF_VERSION}-linux-amd64.zip && \
    rm serf-v${SERF_VERSION}-linux-amd64.zip && \
    mv serf /usr/bin/

# confd Installation
RUN curl -L https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 -o confd && \
  mv confd /usr/bin/confd && \
  chmod +x /usr/bin/confd

# mysql/galera Installation
RUN apt-get clean && apt-get update && \
    apt-get install -y software-properties-common && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
    add-apt-repository 'deb [arch=amd64,i386] http://mirror.jmu.edu/pub/mariadb/repo/10.1/debian jessie main' && \
    apt-get update && \
    apt-get install --fix-missing -y mariadb-server mariadb-client rsync galera-3 xinetd git libssl-dev libxml-sax-expat-incremental-perl && \
    git clone https://github.com/alestic/ec2-consistent-snapshot && \
    mv ec2-consistent-snapshot/ec2-consistent-snapshot /usr/bin/ && \
    rm -rf ec2-consistent-snapshot && \
    PERL_MM_USE_DEFAULT=1 cpan File::Slurp && \
    PERL_MM_USE_DEFAULT=1 cpan IO::Socket::SSL && \
    PERL_MM_USE_DEFAULT=1 cpan Net::Amazon::EC2 && \
    PERL_MM_USE_DEFAULT=1 cpan DateTime::Locale && \
    PERL_MM_USE_DEFAULT=1 cpan DateTime::TimeZone && \
    apt-get remove --purge -y software-properties-common git && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/debconf/*-old && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/*

# Convoy Installation
RUN curl -L https://github.com/rancher/convoy/releases/download/v0.5.0-rc1/convoy.tar.gz -o convoy.tar.gz && \
    tar xvf convoy.tar.gz && \
    cp convoy/convoy convoy/convoy-pdata_tools /usr/bin/ && \
    rm -rf convoy.tar.gz convoy

# Shudder Installation
RUN apt-get update && \
    apt-get install -y git && \
    git clone https://github.com/bdentino/shudder && \
    cd shudder && \
    git reset --hard 2b19380 && \
    pip install . && \
    cd .. && \
    apt-get remove --purge -y git && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/debconf/*-old && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/*

# Status Dependencies (requires dig)
RUN apt-get update && \
    apt-get install -y dnsutils && \
    apt-get remove --purge -y git && \
    apt-get clean -y && \
    apt-get autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /usr/share/locale/* && \
    rm -rf /var/cache/debconf/*-old && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /usr/share/doc/*

COPY common/* /usr/bin/

ENV ETCD_DATA_DIR=/etc/etcd/data
RUN mkdir -p /etc/etcd/data
EXPOSE 2739
EXPOSE 2780
COPY etcd/* /usr/bin/

RUN mkdir -p /etc/confd/conf.d /etc/confd/templates /etc/confd/default
COPY confd/confd.toml /etc/confd/
COPY confd/haproxy.cfg.tmpl /etc/confd/templates/
COPY confd/haproxy.cfg /etc/confd/default/
COPY confd/haproxy.toml /etc/confd/conf.d/
COPY confd/confd-bootstrap /usr/bin/

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
