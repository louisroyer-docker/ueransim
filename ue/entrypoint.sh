#!/usr/bin/env bash

set -e
savedargs=( "$@" )
config_opt=0
while [ $# -gt 0 ]; do
	if [[ $1 == "--config" || $1 == "-c" ]]; then
		config_opt=1
	fi
	shift
done
set -- "${savedargs[@]}"

if  [[ -n "${CONFIG_TEMPLATE}" && -n "${CONFIG_FILE}" ]]; then
	if [ -n "${TEMPLATE_SCRIPT}" ]; then
		echo "[$(date --iso-8601=s)] Running ${TEMPLATE_SCRIPT}${TEMPLATE_SCRIPT_ARGS:+ }${TEMPLATE_SCRIPT_ARGS} for building ${CONFIG_FILE} from ${CONFIG_TEMPLATE}." > /dev/stderr
		"$TEMPLATE_SCRIPT" "$TEMPLATE_SCRIPT_ARGS"
	fi


	# UERANSIM is able to wait for gNB, `wait-for-it` is not required
	if [[ $config_opt -eq 0 ]]; then
		exec nr-ue --config "$CONFIG_FILE" "$@"
	else
		exec nr-ue "$@"
	fi

else
	# UERANSIM is able to wait for gNB, `wait-for-it` is not required
	exec nr-ue "$@"
fi
