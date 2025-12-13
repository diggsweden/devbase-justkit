#!/usr/bin/env bats

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

bats_require_minimum_version 1.13.0

load "${BATS_TEST_DIRNAME}/libs/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-file/load.bash"
load "${BATS_TEST_DIRNAME}/test_helper.bash"

setup() {
  common_setup
  export SCRIPT_DIR="${DEVTOOLS_ROOT}/scripts"
}

teardown() {
  common_teardown
}

@test "setup.sh requires repository URL argument" {
  run "$SCRIPT_DIR/setup.sh"
  
  assert_failure
  assert_output --partial "Usage:"
}

@test "setup.sh requires target directory argument" {
  run "$SCRIPT_DIR/setup.sh" "https://example.com/repo"
  
  assert_failure
  assert_output --partial "Usage:"
}
