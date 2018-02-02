FROM alpine:latest
MAINTAINER Sylvain Desbureaux <sylvain@desbureaux.fr>

# install packages &
## OpenZwave installation &
# grep git version of openzwave &
# untar the files &
# compile &
# "install" in order to be found by domoticz &
## Domoticz installation &
# clone git source in src &
# Domoticz needs the full history to be able to calculate the version string &
# prepare makefile &
# compile &
# remove git and tmp dirs

ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/domoticz/domoticz" \
      org.label-schema.url="https://domoticz.com/" \
      org.label-schema.name="Domoticz" \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.license="GPLv3" \
      org.label-schema.build-date=$BUILD_DATE

RUN 	mkdir /domoticz && \
	cd domoticz && \
	wget -O domoticz_release.tgz "http://www.domoticz.com/download.php?channel=release&type=release&system=Linux&machine=armv7l" && \
	echo "::: Unpacking Domoticz..." && \
	tar xvfz domoticz_release.tgz && \
	rm domoticz_release.tgz

VOLUME /config

EXPOSE 8080

HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:8080/ || exit 1

ENTRYPOINT ["/domoticz/domoticz", "-dbase", "/config/domoticz.db"]
CMD ["-www", "8080"]
