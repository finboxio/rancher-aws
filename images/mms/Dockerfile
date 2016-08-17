FROM ubuntu:xenial

RUN apt-get update && apt-get install -y curl logrotate \
    && apt-get clean

# Get latest from https://mms.mongodb.com/settings/monitoring-agent
RUN curl -sSL https://cloud.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent_latest_amd64.ubuntu1604.deb -o mms.deb
RUN dpkg -i mms.deb
RUN rm mms.deb

ADD monitoring-agent /usr/bin/monitoring-agent
RUN chmod +x /usr/bin/monitoring-agent

ENTRYPOINT ["/usr/bin/monitoring-agent"]

USER mongodb-mms-agent
CMD ["mongodb-mms-monitoring-agent","-conf","/etc/mongodb-mms/monitoring-agent.config"]
