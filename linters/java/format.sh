#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: CC0-1.0

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../../utils/colors.sh"

readonly MAVEN_OPTS="${MAVEN_OPTS:---batch-mode --no-transfer-progress --errors -Dstyle.color=always}"
readonly ACTION="${1:-check}"

check_maven() {
  if ! command -v mvn >/dev/null 2>&1; then
    print_error "mvn not found. Install with: mise install maven"
    return 1
  fi
}

has_pom() {
  [[ -f pom.xml ]]
}

check_format() {
  print_info "Checking Java formatting..."
  if mvn ${MAVEN_OPTS} formatter:validate; then
    print_success "Java formatting check passed"
    return 0
  else
    print_error "Java formatting check failed - run 'just lint-java-fmt-fix' to fix"
    return 1
  fi
}

fix_format() {
  print_info "Formatting Java code..."
  if mvn ${MAVEN_OPTS} formatter:format; then
    print_success "Java code formatted"
    return 0
  else
    print_error "Java formatting failed"
    return 1
  fi
}

main() {
  print_header "JAVA FORMATTING (FORMATTER)"

  if ! has_pom; then
    print_warning "No pom.xml found, skipping"
    return 0
  fi

  if ! check_maven; then
    return 1
  fi

  case "$ACTION" in
  check) check_format ;;
  fix) fix_format ;;
  *)
    print_error "Unknown action: $ACTION"
    printf "Usage: %s [check|fix]\n" "$0"
    return 1
    ;;
  esac
}

main
