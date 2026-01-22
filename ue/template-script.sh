#!/usr/bin/env bash
# Copyright Louis Royer. All rights reserved.
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# SPDX-License-Identifier: AGPL-3.0-or-later

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

if [ -z "$GNBS" ]; then
	echo "Missing mandatory environment variable (GNBS)." > /dev/stderr
	exit 1
fi
if [ -z "$SESSIONS" ]; then
	echo "Missing mandatory environment variable (SESSIONS)." > /dev/stderr
	exit 1
fi
if [ -z "$DEFAULT_NSSAI" ]; then
	echo "Missing mandatory environment variable (DEFAULT_NSSAI)." > /dev/stderr
	exit 1
fi
if [ -z "$CONFIGURED_NSSAI" ]; then
	echo "Missing mandatory environment variable (CONFIGURED_NSSAI)." > /dev/stderr
	exit 1
fi

# GNB
IFS=$'\n'
GNB_SUB=""
for GNB_IP in ${GNBS}; do
	if [ -n "${GNB_IP}" ]; then
		GNB_SUB="${GNB_SUB}\n  ${GNB_IP}"
	fi
done

# Sessions
SESSIONS_SUB=""
for S in ${SESSIONS}; do
	if [ -n "${S}" ]; then
		SESSIONS_SUB="${SESSIONS_SUB}\n  ${S}"
	fi
done

# Default NSSAI
DEFAULT_NSSAI_SUB=""
for NSSAI in ${DEFAULT_NSSAI}; do
	if [ -n "${NSSAI}" ]; then
		DEFAULT_NSSAI_SUB="${DEFAULT_NSSAI_SUB}\n  ${NSSAI}"
	fi
done

# Configured NSSAI
CONFIGURED_NSSAI_SUB=""
for NSSAI in ${CONFIGURED_NSSAI}; do
	if [ -n "${NSSAI}" ]; then
		CONFIGURED_NSSAI_SUB="${CONFIGURED_NSSAI_SUB}\n  ${NSSAI}"
	fi
done

awk \
	-v MCC="${MCC:-001}" \
	-v MNC="${MNC:-01}" \
	-v MSISDN="${MSISDN:-0000000000}" \
	-v KEY="${KEY:-8baf473f2f8fd09487cccbd7097c6862}" \
	-v OP="${OP:-8e27b6af0e692e750f32667a3b14605d}" \
	-v AMF="${AMF:-8000}" \
	-v GNB="${GNB_SUB}" \
	-v SESSIONS="${SESSIONS_SUB}" \
	-v DEFAULT_NSSAI="${DEFAULT_NSSAI_SUB}" \
	-v CONFIGURED_NSSAI="${CONFIGURED_NSSAI_SUB}" \
	'{
		sub(/%MCC/, MCC);
		sub(/%MNC/, MNC);
		sub(/%MSISDN/, MSISDN);
		sub(/%KEY/, KEY);
		sub(/%OP/, OP);
		sub(/%AMF/, AMF);
		sub(/%GNB/, GNB);
		sub(/%SESSIONS/, SESSIONS);
		sub(/%DEFAULT_NSSAI/, DEFAULT_NSSAI);
		sub(/%CONFIGURED_NSSAI/, CONFIGURED_NSSAI);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
