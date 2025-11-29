#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../utils/colors.sh"

activate_mise() {
  if command -v mise >/dev/null 2>&1; then
    PROMPT_COMMAND="${PROMPT_COMMAND:-}"
    eval "$(mise activate bash)"
  fi
}

check_tool() {
  local tool="$1"
  if command -v "$tool" >/dev/null 2>&1; then
    print_success "$tool"
    return 0
  else
    print_error "$tool"
    return 1
  fi
}

main() {
  activate_mise

  local tools=("$@")
  if [[ ${#tools[@]} -eq 0 ]]; then
    tools=(mise git just)
  fi

  local missing_count=0

  printf "Checking tools...\n"
  printf "=================\n"

  for tool in "${tools[@]}"; do
    if ! check_tool "$tool"; then
      missing_count=$((missing_count + 1))
    fi
  done

  printf "\n"

  if [[ $missing_count -gt 0 ]]; then
    print_error "Missing $missing_count tools!"
    printf "\n"
    print_info "Run: mise install"
    return 1
  else
    print_success "All tools available!"
    return 0
  fi
}

main "$@"
