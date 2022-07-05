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
		AMF_CONFIGS_SUB="${AMF_CONFIGS_SUB}\n  - ${AMF}"
	fi
done

# Supported NSSAI
SUPPORTED_NSSAIS_SUB=""
for NSSAI in ${SUPPORTED_NSSAIS}; do
	if [ -n "${NSSAI}" ]; then
		SUPPORTED_NSSAIS_SUB="${SUPPORTED_NSSAIS_SUB}\n  - ${NSSAI}"
	fi
done

cp "${CONFIG_TEMPLATE}" "${CONFIG_FILE}"
sed -i "s/%SESSIONS/${SESSIONS_SUB}/g" "${CONFIG_FILE}"
sed \
	-i "s/%MCC/${MCC:-001}/g" \
	-i "s/%MNC/${MNC:-01}/g" \
	-i "s/%NCI/${NCI:-0x000000010}/g" \
	-i "s/%ID_LEN/${ID_LEN:-32}/g" \
	-i "s/%TAC/${TAC:-1}/g" \
	-i "s/%RLS_IP/${RLS_IP}/g" \
	-i "s/%N2_IP/${RLS_IP}/g" \
	-i "s/%N3_IP/${RLS_IP}/g" \
	-i "s/%AMF_CONFIGS/${AMF_CONFIGS_SUB}/g" \
	-i "s/%SUPPORTED_NSSAIS/${SUPPORTED_NSSAIS_SUB}/g" \
	
"${CONFIG_FILE}"
