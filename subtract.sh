#! /bin/bash
# Collect all dependencies from GraphML files.
set -o nounset
set -o errexit

readonly DEPAN_CMD=$(cfg DEPAN_CMD)

function subtract {
  local name="$1"
  local base="$2"
  local minus="$3"
  "${DEPAN_CMD}" subtract "${name}.dni" "${base}/${name}.dgi" "${minus}/${name}.dgi"
  # echo "${DEPAN_CMD}" subtract "${name}.dni" "${base}/${name}.dgi" "${minus}/${name}.dgi"
  # "${DEPAN_CMD}" subtract "${name}.dni" "${base}/${name}.dgi" "${minus}/${name}.dgi" -vmargs -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8080
}

function main {
  local name="$1"
  local base="$2"
  local minus="$3"
  subtract "${name}" "${base}" "${minus}"
}

main "$@"
