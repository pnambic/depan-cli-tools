#! /bin/bash
# Collect all dependencies from GraphML files.
set -o nounset
set -o errexit

readonly DEPAN_CMD=$(cfg DEPAN_CMD)
readonly DST_DIR="inv_$(date '+%Y%m%d_%H%M')"

function analyzeJava {
  local dst="$1"
  local src="$2"
  "${DEPAN_CMD}" analyze java "${DST_DIR}/${dst}" "${src}"
}

function collectInputs {
  while read file; do
    local dst=$(getOutputFileName "${file}")
    analyzeJava "${dst}.dgi" "${file}" 
  done
}

function collectTreePattern {
  local tree="$1"
  local pat="$2"
  find "${tree}" -name "${pat}" | collectInputs
}

function collectDepanJava {
  local tree="$1"
  collectTreePattern "${tree}" 'com.google.devtools.depan.*.jar'
}

function collectTplJava {
  local tree="$1"
  # Also need to unpack bundled jar in depan-*-library_*.jar files
  collectTreePattern "${tree}" 'com.google.gauva_*.jar'
  collectTreePattern "${tree}" 'joda-time_*.jar'
}

function getOutputFileName {
  local base=$(basename "${1}")
  echo ${base%_*}
}

function collectProjectJava {
  local tree=$1
  collectDepanJava "${tree}"
  collectTplJava "${tree}"
}

function usage {
  cat >&2 <<HELP
Usage: $(basename "$0") [ tree ]
HELP
}

function main {
  local tree="${1:?mising arg 1: plugin tree}"
  mkdir -p "${DST_DIR}"
  collectProjectJava "${tree}"
}

main "$@"
