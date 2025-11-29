#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/colors.sh"

main() {
  if just lint-all; then
    printf "\n%b━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%b\n" "${GREEN}" "${NC}"
    printf "%b     %s ALL CHECKS PASSED!%b\n" "${GREEN}" "${CHECK}" "${NC}"
    printf "%b━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%b\n" "${GREEN}" "${NC}"
    return 0
  else
    printf "\n%b━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%b\n" "${RED}" "${NC}"
    printf "%b     %s SOME CHECKS FAILED%b\n" "${RED}" "${CROSS}" "${NC}"
    printf "%b━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━%b\n" "${RED}" "${NC}"
    printf "\n%bRun %bjust lint-fix%b to auto-fix some issues%b\n" "${YELLOW}" "${GREEN}" "${YELLOW}" "${NC}"
    return 1
  fi
}

main
