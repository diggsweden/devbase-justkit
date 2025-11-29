#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: CC0-1.0

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../utils/colors.sh"

readonly MAVEN_OPTS="${MAVEN_OPTS:---batch-mode --no-transfer-progress --errors -Dstyle.color=always}"

check_maven() {
  if ! command -v mvn >/dev/null 2>&1; then
    print_error "mvn not found. Install with: mise install maven"
    return 1
  fi
}

has_pom() {
  [[ -f pom.xml ]]
}

main() {
  print_header "JAVA TESTS (MAVEN)"

  if ! has_pom; then
    print_warning "No pom.xml found, skipping"
    return 0
  fi

  if ! check_maven; then
    return 1
  fi

  print_info "Running tests..."
  if mvn ${MAVEN_OPTS} clean verify; then
    print_success "Java tests passed"
    return 0
  else
    print_error "Java tests failed"
    return 1
  fi
}

main
