#! /bin/bash
# Collect all dependencies from GraphML files.
set -o nounset
set -o errexit

readonly DEPAN_CMD=$(cfg DEPAN_CMD)
readonly DST_DIR="env_$(date '+%Y%m%d_%H%M')"

function analyzeGraphML {
  local dst="$1"
  local src="$2"
  local kind="$3"
  "${DEPAN_CMD}" analyze graphml "${DST_DIR}/${dst}" "${src}" "${kind}"
}

function collectGraphML {
  local tree="$1"
  find "${tree}" -name '*.graphml' \
  | while read file; do
    local dst=$(getOutputFileName "${file}")
    analyzeGraphML "${dst}.dgi" "${file}" maven
  done
}

function getOutputFileName {
  local file=$1
  local parent=$(dirname "${file}")
  local base_one=$(basename "${parent}")
  case "${base_one}" in
    'prod'|'test')
      local base_two=$(basename $(dirname "${parent}"))
      echo "${base_two}_${base_one}"
      ;;
    *)
      echo "${base_one}"
      ;;
  esac
}

function usage {
  cat >&2 <<HELP
Usage: $(basename "$0") [ tree ]
HELP
}

function main {
  local tree="$1"
  mkdir -p "${DST_DIR}"
  collectGraphML "${tree}"
}

main "$@"
