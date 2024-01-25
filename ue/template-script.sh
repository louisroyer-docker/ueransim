#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

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
