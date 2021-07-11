#!/usr/bin/env bash

set -Eeuio pipefail
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
source ${script_dir}/lib/lib.sh
source ${script_dir}/lib/migration_mode.sh

setup_colors
parse_params "$@"

case ${MODE} in 
    sync) 
        sync_data "${SOURCE}" "${DESTINATION}"
	;;
    diff)
	diff_data "${SOURCE}" "${DESTINATION}"
	;;
    *) die "Unknown mode variable: ${MODE}" ;;
esac

