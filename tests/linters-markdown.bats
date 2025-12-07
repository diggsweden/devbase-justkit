#!/usr/bin/env bats

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

# Tests for linters/markdown.sh

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

@test "markdown.sh check passes on valid markdown" {
  skip_if_not_installed rumdl
  
  cat > test.md << 'EOF'
# Test

This is a test.
EOF
  
  run -0 "${BATS_TEST_DIRNAME}/../linters/markdown.sh" check
  
  assert_success
  assert_output --partial "MARKDOWN"
}

@test "markdown.sh handles missing rumdl gracefully" {
  if command -v rumdl >/dev/null 2>&1; then
    skip "rumdl is installed, cannot test missing tool behavior"
  fi
  
  run -0 "${BATS_TEST_DIRNAME}/../linters/markdown.sh" check
  
  assert_success
  assert_output --partial "not found in PATH"
}

@test "markdown.sh accepts check and fix actions" {
  skip_if_not_installed rumdl
  
  cat > test.md << 'EOF'
# Test
EOF
  
  run "${BATS_TEST_DIRNAME}/../linters/markdown.sh" check
  assert_output --partial "MARKDOWN"
  
  run "${BATS_TEST_DIRNAME}/../linters/markdown.sh" fix
  assert_output --partial "MARKDOWN"
}

skip_if_not_installed() {
  if ! command -v "$1" >/dev/null 2>&1; then
    skip "$1 not installed"
  fi
}
