FROM louisroyer/base-irit:latest
RUN apt-get update -q && DEBIAN_FRONTEND=non-interactive apt-get install -qy --no-install-recommends --no-install-suggests \
    ueransim \
    && apt-get upgrade -qy \
    && rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

COPY ./template-script.sh /usr/local/bin/template-script.sh
ENV TEMPLATE_SCRIPT="template-script.sh"
ENV TEMPLATE_SCRIPT_ARGS=""

COPY ./template-gnb.yaml /etc/ueransim/template-gnb.yaml
ENV CONFIG_FILE="/etc/ueransim/gnb.yaml"
ENV CONFIG_TEMPLATE="/etc/ueransim/template-gnb.yaml"

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
