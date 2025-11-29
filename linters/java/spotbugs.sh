#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: CC0-1.0

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../utils/colors.sh"

readonly MAVEN_OPTS="${MAVEN_OPTS:---batch-mode --no-transfer-progress --errors -Dstyle.color=always}"

main() {
  print_header "JAVA SPOTBUGS"

  if [[ ! -f pom.xml ]]; then
    print_warning "No pom.xml found, skipping"
    return 0
  fi

  if ! command -v mvn >/dev/null 2>&1; then
    print_error "mvn not found. Install with: mise install maven"
    return 1
  fi

  if mvn ${MAVEN_OPTS} spotbugs:check; then
    print_success "SpotBugs passed"
    return 0
  else
    print_error "SpotBugs failed"
    return 1
  fi
}

main
