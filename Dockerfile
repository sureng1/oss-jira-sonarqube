FROM openjdk:17.0.2-jdk-buster as jdk_base
FROM ubuntu:22.04

COPY --from=jdk_base /usr/local/openjdk-17 /usr/local/openjdk-17/
ENV JAVA_HOME /usr/local/openjdk-17
ENV TZ=UTC
ENV DEBIAN_FRONTEND=noninteractive
# no enter ok for jira install
ENV JIRA_INSTALLER_TYPE=express
ENV JIRA_INSTALLER_DISABLE_INTERACTIVE=true



RUN apt-get update && apt-get install -y fontconfig

# Install Jira
COPY atlassian-jira-software-8.19.1-x64.bin /tmp/jira.bin
COPY atlassian-extras-3.4.6.jar /tmp/atlassian-extras-3.4.6.jar
COPY response.varfile /tmp/response.varfile
RUN chmod +x /tmp/jira.bin && \ 
    cd /tmp && \
    ./jira.bin -q -varfile response.varfile

RUN rm -f /opt/jira/atlassian-jira/WEB-INF/lib/atlassian-extras-3.4.6.jar && \
    cp /tmp/atlassian-extras-3.4.6.jar /opt/jira/atlassian-jira/WEB-INF/lib && \
    /opt/jira/bin/start-jira.sh && \
    /opt/jira/bin/stop-jira.sh

CMD ["/opt/jira/bin/start-jira.sh"]