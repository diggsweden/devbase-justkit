#!/usr/bin/env bats

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

# Tests for scripts/check-tools.sh

bats_require_minimum_version 1.13.0

load "${BATS_TEST_DIRNAME}/libs/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-file/load.bash"

@test "check-tools.sh exists and is executable" {
  assert_file_exists "${BATS_TEST_DIRNAME}/../scripts/check-tools.sh"
  assert_file_executable "${BATS_TEST_DIRNAME}/../scripts/check-tools.sh"
}

@test "check-tools.sh checks for specified tools" {
  run "${BATS_TEST_DIRNAME}/../scripts/check-tools.sh" bash
  
  assert_output --partial "bash"
}

@test "check-tools.sh detects missing tools" {
  run -1 "${BATS_TEST_DIRNAME}/../scripts/check-tools.sh" nonexistent-tool-12345
  
  assert_failure
  assert_output --partial "Missing"
}

@test "check-tools.sh succeeds when all tools present" {
  run -0 "${BATS_TEST_DIRNAME}/../scripts/check-tools.sh" bash sh
  
  assert_success
}
