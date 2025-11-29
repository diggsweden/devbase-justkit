#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/colors.sh"

readonly MODE="${1:-check}"

find_shell_scripts() {
  find . -type f \( -name "*.sh" -o -name "*.bash" \) -not -path "./.git/*" 2>/dev/null
}

check_format() {
  local scripts="$1"
  if echo "$scripts" | xargs -r shfmt -i 2 -d; then
    print_success "Shell script formatting check passed"
    return 0
  else
    print_error "Shell script formatting failed - run 'just lint-shell-fmt-fix' to fix"
    return 1
  fi
}

fix_format() {
  local scripts="$1"
  if echo "$scripts" | xargs -r shfmt -i 2 -w; then
    print_success "Shell scripts formatted"
    return 0
  else
    print_error "Shell script formatting failed"
    return 1
  fi
}

main() {
  print_header "SHELL SCRIPT FORMATTING (SHFMT)"

  if ! command -v shfmt >/dev/null 2>&1; then
    print_error "shfmt not found. Install with: mise install"
    return 1
  fi

  local scripts
  scripts=$(find_shell_scripts)

  if [[ -z "$scripts" ]]; then
    print_warning "No shell scripts found to format"
    return 0
  fi

  case "$MODE" in
  check) check_format "$scripts" ;;
  fix) fix_format "$scripts" ;;
  *)
    print_error "Unknown mode: $MODE"
    printf "Usage: %s [check|fix]\n" "$0"
    return 1
    ;;
  esac
}

main
