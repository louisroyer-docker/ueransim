#!/usr/bin/env bash
# Copyright 2024 Louis Royer. All rights reserved.
# Use of this source code is governed by a MIT-style license that can be
# found in the LICENSE file.
# SPDX-License-Identifier: MIT

set -e
mkdir -p "$(dirname "${CONFIG_FILE}")"

if [ -z "$RLS_IP" ]; then
	echo "Missing mandatory environment variable (RLS_IP)." > /dev/stderr
	exit 1
fi
if [ -z "$N2_IP" ]; then
	echo "Missing mandatory environment variable (N2_IP)." > /dev/stderr
	exit 1
fi
if [ -z "$N3_IP" ]; then
	echo "Missing mandatory environment variable (N3_IP)." > /dev/stderr
	exit 1
fi
if [ -z "$AMF_CONFIGS" ]; then
	echo "Missing mandatory environment variable (AMF_CONFIGS)." > /dev/stderr
	exit 1
fi
if [ -z "$SUPPORTED_NSSAIS" ]; then
	echo "Missing mandatory environment variable (SUPPORTED_NSSAIS)." > /dev/stderr
	exit 1
fi

# AMF Configurations
IFS=$'\n'
AMF_CONFIGS_SUB=""
for AMF in ${AMF_CONFIGS}; do
	if [ -n "${AMF}" ]; then
		AMF_CONFIGS_SUB="${AMF_CONFIGS_SUB}\n  ${AMF}"
	fi
done

# Supported NSSAI
SUPPORTED_NSSAIS_SUB=""
for NSSAI in ${SUPPORTED_NSSAIS}; do
	if [ -n "${NSSAI}" ]; then
		SUPPORTED_NSSAIS_SUB="${SUPPORTED_NSSAIS_SUB}\n  ${NSSAI}"
	fi
done

awk \
	-v MCC="${MCC:-001}" \
	-v MNC="${MNC:-01}" \
	-v NCI="${NCI:-0x000000010}" \
	-v ID_LEN="${ID_LEN:-32}" \
	-v TAC="${TAC:-1}" \
	-v RLS_IP="${RLS_IP}" \
	-v N2_IP="${N2_IP}" \
	-v N3_IP="${N3_IP}" \
	-v AMF_CONFIGS="${AMF_CONFIGS_SUB}" \
	-v SUPPORTED_NSSAIS="${SUPPORTED_NSSAIS_SUB}" \
	'{
		sub(/%MCC/, MCC);
		sub(/%MNC/, MNC);
		sub(/%NCI/, NCI);
		sub(/%ID_LEN/, ID_LEN);
		sub(/%TAC/, TAC);
		sub(/%RLS_IP/, RLS_IP);
		sub(/%N2_IP/, N2_IP);
		sub(/%N3_IP/, N3_IP);
		sub(/%AMF_CONFIGS/, AMF_CONFIGS);
		sub(/%SUPPORTED_NSSAIS/, SUPPORTED_NSSAIS);
		print;
	}' \
	"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
