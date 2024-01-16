# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

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
COPY ./routing.sh /usr/local/bin/routing.sh
ENV ROUTING_SCRIPT="routing.sh"

COPY ./template-script.sh /usr/local/bin/template-script.sh
ENV TEMPLATE_SCRIPT="template-script.sh"
ENV TEMPLATE_SCRIPT_ARGS=""

COPY ./template-ue.yaml /etc/ueransim/template-ue.yaml
ENV CONFIG_FILE="/etc/ueransim/ue.yaml"
ENV CONFIG_TEMPLATE="/etc/ueransim/template-ue.yaml"

ENTRYPOINT ["entrypoint.sh"]
CMD ["--help"]
