#!/usr/bin/env bats

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

# Tests for linters/shell.sh

bats_require_minimum_version 1.13.0

load "${BATS_TEST_DIRNAME}/libs/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-file/load.bash"

setup() {
  TEST_DIR="$(temp_make)"
  export TEST_DIR
  cd "$TEST_DIR"
}

teardown() {
  temp_del "$TEST_DIR"
}

@test "shell.sh checks shell scripts when present" {
  skip_if_not_installed shellcheck
  
  cat > test.sh << 'EOF'
#!/bin/bash
echo "test"
EOF
  chmod +x test.sh
  
  run -0 "${BATS_TEST_DIRNAME}/../linters/shell.sh"
  
  assert_success
  assert_output --partial "SHELL"
}

@test "shell.sh handles no shell scripts gracefully" {
  run -0 "${BATS_TEST_DIRNAME}/../linters/shell.sh"
  
  assert_success
  assert_output --partial "No shell scripts"
}

@test "shell.sh handles missing shellcheck gracefully" {
  if command -v shellcheck >/dev/null 2>&1; then
    skip "shellcheck is installed, cannot test missing tool behavior"
  fi
  
  cat > test.sh << 'EOF'
#!/bin/bash
echo "test"
EOF
  
  run -0 "${BATS_TEST_DIRNAME}/../linters/shell.sh"
  
  assert_success
  assert_output --partial "not found in PATH"
}

skip_if_not_installed() {
  if ! command -v "$1" >/dev/null 2>&1; then
    skip "$1 not installed"
  fi
}
