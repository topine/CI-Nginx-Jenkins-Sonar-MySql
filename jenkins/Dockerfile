FROM ubuntu:16.04
MAINTAINER Anderson Topine <support@topine.eu>

RUN apt-get update && apt-get -y upgrade && apt-get -y install default-jdk vim curl docker.io sudo && apt-get clean

ENV JENKINS_HOME /opt/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container, 
# ensure you use the same uid
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

#add jenkins to docker group

RUN usermod -aG docker ${user}

# Jenkins home directory is a volume, so configuration and build history 
# can be persisted and survive image upgrades
VOLUME /opt/jenkins_home

# Install docker-machine used for deployment

RUN curl -L https://github.com/docker/machine/releases/download/v0.9.0-rc2/docker-machine-`uname -s`-`uname -m` >/tmp/docker-machine \
 && chmod +x /tmp/docker-machine \
 && cp /tmp/docker-machine /usr/local/bin/docker-machine

#Docker machine files location with volume
ENV MACHINE_STORAGE_PATH /var/.docker/machine
VOLUME /var/.docker

#Create a link for the docker files certs.
RUN mkdir /home/ubuntu && cd /home/ubuntu && ln -s /var/.docker/ .docker  


# `/usr/share/jenkins/ref/` contains all reference configuration we want 
# to set on a fresh new installation. Use it to bundle additional plugins 
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d

ENV TINI_VERSION 0.13.1
ENV TINI_SHA 0f78709a0e3c80e7c9119fdc32c2bc0f4cfc4cab

# Use tini as subreaper in Docker container to adopt zombie processes 
RUN curl -fsSL https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini-static-amd64 -o /bin/tini && chmod +x /bin/tini \
  && echo "$TINI_SHA  /bin/tini" | sha1sum -c -

COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy

# jenkins version being bundled in this docker image
ARG JENKINS_VERSION
ENV JENKINS_VERSION ${JENKINS_VERSION:-2.32.1}

# jenkins.war checksum, download will be validated using it
ARG JENKINS_SHA=1b65dc498ba7ab1f5cce64200b920a8716d90834

# Can be used to customize where jenkins.war get downloaded from
ARG JENKINS_URL=https://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war

# could use ADD but this one does not check Last-Modified header neither does it allow to control checksum 
# see https://github.com/docker/docker/issues/8331
RUN curl -fsSL ${JENKINS_URL} -o /usr/share/jenkins/jenkins.war \
  && echo "${JENKINS_SHA}  /usr/share/jenkins/jenkins.war" | sha1sum -c -

ENV JENKINS_UC https://updates.jenkins.io
RUN chown -R ${user} "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

ENV COPY_REFERENCE_FILE_LOG $JENKINS_HOME/copy_reference_file.log

USER ${user}

COPY jenkins-support /usr/local/bin/jenkins-support
COPY jenkins.sh /usr/local/bin/jenkins.sh

# from a derived Dockerfile, can use `RUN plugins.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY plugins.sh /usr/local/bin/plugins.sh
COPY install-plugins.sh /usr/local/bin/install-plugins.sh

USER root

# Grab gosu for easy step-down from root.
ADD https://github.com/tianon/gosu/releases/download/1.5/gosu-amd64 /usr/local/bin/gosu

# Change the group of the jenkins user to root, because that group has no 
# special rights on most host systems.
RUN chmod 755 /usr/local/bin/gosu && usermod -g root ${user}


ENTRYPOINT groupmod -g $(stat -c "%g" /var/run/docker.sock) docker \
           && chown jenkins:jenkins $JENKINS_HOME \
           && gosu jenkins /bin/tini -- /usr/local/bin/jenkins.sh

