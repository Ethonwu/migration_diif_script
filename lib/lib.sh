#!/usr/bin/env bash
setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  MODE=''
  SOURCE=''
  DESTINATION=''
  args=("$@")
  [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments use --help or -h to see usage"
  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    -m | --mode)
      MODE="${2-}"
      shift
      ;;
    -s | --source)
      SOURCE="${2-}"
      shift
      ;;
    -d | --destination)
      DESTINATION="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done
  # check required params and arguments
  [[ -z ${MODE} ]] && die "Missing required parameter: mode"    
  [[ -z ${SOURCE} ]] && die "Missing required parameter: source"
  [[ -z ${DESTINATION} ]] && die "Missing required parameter: destination"

  return 0
}
usage() {
  cat <<EOF
Usage:

Script description here.

Available options:

-h, --help            Print this help and exit
-m, --mode sync|diff  Two mode
		      sync mode: sync data to destination
		      diff mode: compare data between source and destination 	  
-s, --source          Source path
-v, --verbose   Print script debug info
-d, --destination     Destination path

Example: 
sync:
    sh migration_cdsw.sh -m sync -s <source folder> -d root@<IP>:<Dest folder>
diff:
    sh migration_cdsw.sh -m diff -s <source folder> -d root@<IP>:<Dest folder>

EOF
  exit
}
