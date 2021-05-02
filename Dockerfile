ARG IMAGE=intersystems/irishealth:2020.1.0.215.0.20264
FROM $IMAGE

USER root

RUN apt-get update && apt-get install -y git curl nano


RUN mkdir /opt/iriscode && chown ${ISC_PACKAGE_IRISUSER}:${ISC_PACKAGE_IRISGROUP} /opt/iriscode && chmod 775 /opt/iriscode

# Prepare a code directory and run git init
USER ${ISC_PACKAGE_IRISUSER}
WORKDIR /opt/iriscode
RUN git init && git config --global user.email "git@on.iris" && git config --global user.name "Git on IRIS"


USER root
WORKDIR /opt/irisbuild
RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisbuild

USER ${ISC_PACKAGE_MGRUSER}

#COPY  Installer.cls .
COPY src src
COPY module.xml module.xml
COPY iris.script iris.script

RUN iris start IRIS \
	&& iris session IRIS < iris.script \
    && iris stop IRIS quietly
