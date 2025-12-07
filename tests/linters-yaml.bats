#!/usr/bin/env bats

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

# Tests for linters/yaml.sh

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

@test "yaml.sh check passes on valid YAML" {
  skip_if_not_installed yamlfmt
  
  cat > test.yaml << 'EOF'
key: value
list:
  - item1
  - item2
EOF
  
  run -0 "${BATS_TEST_DIRNAME}/../linters/yaml.sh" check
  
  assert_success
  assert_output --partial "YAML"
}

@test "yaml.sh handles missing yamlfmt gracefully" {
  if command -v yamlfmt >/dev/null 2>&1; then
    skip "yamlfmt is installed, cannot test missing tool behavior"
  fi
  
  run -0 "${BATS_TEST_DIRNAME}/../linters/yaml.sh" check
  
  assert_success
  assert_output --partial "not found in PATH"
}

@test "yaml.sh accepts check and fix actions" {
  skip_if_not_installed yamlfmt
  
  cat > test.yaml << 'EOF'
key: value
EOF
  
  run "${BATS_TEST_DIRNAME}/../linters/yaml.sh" check
  assert_output --partial "YAML"
  
  run "${BATS_TEST_DIRNAME}/../linters/yaml.sh" fix
  assert_output --partial "YAML"
}

@test "yaml.sh rejects unknown actions" {
  skip_if_not_installed yamlfmt
  
  run -1 "${BATS_TEST_DIRNAME}/../linters/yaml.sh" invalid
  
  assert_failure
  assert_output --partial "Unknown action"
}

# Helper function
skip_if_not_installed() {
  if ! command -v "$1" >/dev/null 2>&1; then
    skip "$1 not installed"
  fi
}
