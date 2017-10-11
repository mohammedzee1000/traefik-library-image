FROM registry.centos.org/centos/centos:7

RUN yum -y update && yum clean all
ENV VERSION="${VERSION}" \
    ARCH="${ARCH}"

RUN mkdir -p /opt/scripts /etc/traefik
ADD ./install.sh ./entrypoint.sh ./fix-permissions.sh ./passwd.template /opt/scripts/
RUN chmod -R +x /opt/scripts && sh /opt/scripts/install.sh
EXPOSE 80
ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
CMD ["traefik"]

# Metadata
LABEL org.label-schema.vendor="Containous" \
      org.label-schema.url="https://traefik.io" \
      org.label-schema.name="Traefik" \
      org.label-schema.description="A modern reverse-proxy" \
      org.label-schema.version="${VERSION}" \
      org.label-schema.docker.schema-version="1.0"

WORKDIR /etc/traefik
USER traefik
