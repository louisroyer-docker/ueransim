FROM louisroyer/base-irit:latest

LABEL maintainer="Louis Royer <louis.royer@irit.fr>" \
      org.opencontainers.image.authors="Louis Royer <louis.royer@irit.fr>" \
      org.opencontainers.image.source="https://github.com/louisroyer-docker/ueransim"

# Used to disable caching of next steps, if not build since 1 day,
# allowing to search and apply security upgrades
ARG BUILD_DATE=""

RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    ueransim \
    && apt-get upgrade -qy \
    && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
# no routing script is provided, but you are free to use one
ENV ROUTING_SCRIPT=""

COPY ./template-script.sh /usr/local/bin/template-script.sh
ENV TEMPLATE_SCRIPT="template-script.sh"
ENV TEMPLATE_SCRIPT_ARGS=""

COPY ./template-gnb.yaml /etc/ueransim/template-gnb.yaml
ENV CONFIG_FILE="/etc/ueransim/gnb.yaml"
ENV CONFIG_TEMPLATE="/etc/ueransim/template-gnb.yaml"

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
