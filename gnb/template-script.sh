#!/usr/bin/env bash
set -e
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

sed \
	-e "s/%MCC/${MCC:-001}/g" \
	-e "s/%MNC/${MNC:-01}/g" \
	-e "s/%NCI/${NCI:-0x000000010}/g" \
	-e "s/%ID_LEN/${ID_LEN:-32}/g" \
	-e "s/%TAC/${TAC:-1}/g" \
	-e "s/%RLS_IP/${RLS_IP}/g" \
	-e "s/%N2_IP/${RLS_IP}/g" \
	-e "s/%N3_IP/${RLS_IP}/g" \
	-e "s/%AMF_CONFIGS/${AMF_CONFIGS_SUB}/g" \
	-e "s/%SUPPORTED_NSSAIS/${SUPPORTED_NSSAIS_SUB}/g" \
"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
