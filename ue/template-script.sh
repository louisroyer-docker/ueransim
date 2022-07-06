#!/usr/bin/env bash
set -e
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
GNB_SUB="\n"
for GNB_IP in ${GNBS}; do
	if [ -n "${GNB_IP}" ]; then
		GNB_SUB="${GNB_SUB}\n  ${GNB_IP}"
	fi
done

# Sessions
SESSIONS_SUB="\n"
for S in ${SESSIONS}; do
	if [ -n "${S}" ]; then
		SESSIONS_SUB="${SESSIONS_SUB}\n  ${S}"
	fi
done

# Default NSSAI
DEFAULT_NSSAI_SUB="\n"
for NSSAI in ${DEFAULT_NSSAI}; do
	if [ -n "${NSSAI}" ]; then
		DEFAULT_NSSAI_SUB="${DEFAULT_NSSAI_SUB}\n  ${NSSAI}"
	fi
done

# Configured NSSAI
CONFIGURED_NSSAI_SUB="\n"
for NSSAI in ${CONFIGURED_NSSAI}; do
	if [ -n "${NSSAI}" ]; then
		CONFIGURED_NSSAI_SUB="${CONFIGURED_NSSAI_SUB}\n  ${NSSAI}"
	fi
done

sed \
	-e "s/%MCC/${MCC:-001}/g" \
	-e "s/%MNC/${MNC:-01}/g" \
	-e "s/%MSISDN/${MSISDN:-0000000000}/g" \
	-e "s/%KEY/${KEY:-8baf473f2f8fd09487cccbd7097c6862}/g" \
	-e "s/%OP/${OP:-8e27b6af0e692e750f32667a3b14605d}/g" \
	-e "s/%AMF/${AMF:-8000}/g" \
	-e "s/%GNB/${GNB_SUB}/g" \
	-e "s/%SESSIONS/${SESSIONS_SUB}/g" \
	-e "s/%DEFAULT_NSSAI/${DEFAULT_NSSAI_SUB}/g" \
	-e "s/%CONFIGURED_NSSAI/${CONFIGURED_NSSAI_SUB}/g" \
"${CONFIG_TEMPLATE}" > "${CONFIG_FILE}"
