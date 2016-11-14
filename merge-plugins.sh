#! /bin/bash
# Collect all dependencies from GraphML files.
set -o nounset
set -o errexit

readonly DEPAN_CMD=$(cfg DEPAN_CMD)
readonly DST_DIR="inv_$(date '+%Y%m%d_%H%M')"

function unionDir {
  local dst="$1"
  local src="$2"
  local dstPath="${DST_DIR}/${dst}"
  find "${src}" -name '*.dgi' -type f \
  | xargs "${DEPAN_CMD}" union "${dstPath}"
  # | xargs -I{} "${DEPAN_CMD}" union "${dstPath}" {} -vmargs -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8080
  # | xargs echo "${DEPAN_CMD}" union "${dstPath}" -vmargs -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=8080
  echo output to "${dstPath}"
}

function usage {
  cat >&2 <<HELP
Usage: $(basename "$0") dst-file { merge-files }
HELP
}

function main {
  local dst="${1:?Arg 1: destination filename required}"
  local src="${2:?Arg 2: source graph info directory required}"
  mkdir -p "${DST_DIR}"
  unionDir "${dst}" "${src}"
}

main "$@"
