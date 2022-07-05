FROM louisroyer/base-irit:latest
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    ueransim \
    && apt-get upgrade -qy \
    && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./routing.sh /usr/local/bin/routing.sh
ENV ROUTING_SCRIPT="routing.sh"

COPY ./template-script.sh /usr/local/bin/template-script.sh
ENV TEMPLATE_SCRIPT="template-script.sh"
ENV TEMPLATE_SCRIPT_ARGS=""

COPY ./template-ue.yaml /etc/ueransim/template-ue.yaml
ENV CONFIG_UE="/etc/ueransim/ue.yaml"
ENV CONFIG_TEMPLATE="/etc/ueransim/template-ue.yaml"

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
