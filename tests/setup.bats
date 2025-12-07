#!/usr/bin/env bats

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

# Tests for scripts/setup.sh

bats_require_minimum_version 1.13.0

load "${BATS_TEST_DIRNAME}/libs/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-file/load.bash"

setup() {
  TEST_DIR="$(temp_make)"
  export TEST_DIR
  export SCRIPT_DIR="${BATS_TEST_DIRNAME}/../scripts"
}

teardown() {
  temp_del "$TEST_DIR"
}

@test "setup.sh exists and is executable" {
  assert_file_exists "$SCRIPT_DIR/setup.sh"
  assert_file_executable "$SCRIPT_DIR/setup.sh"
}

@test "setup.sh requires repository URL argument" {
  run -1 "$SCRIPT_DIR/setup.sh"
  
  assert_failure
}

@test "setup.sh requires target directory argument" {
  run -1 "$SCRIPT_DIR/setup.sh" "https://example.com/repo"
  
  assert_failure
}
