#!/usr/bin/env bats

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

bats_require_minimum_version 1.13.0

load "${BATS_TEST_DIRNAME}/libs/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-file/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-mock/stub.bash"
load "${BATS_TEST_DIRNAME}/test_helper.bash"

setup() {
  common_setup
  export LINTERS_DIR="${DEVTOOLS_ROOT}/linters"
  cd "$TEST_DIR"
}

teardown() {
  unstub shellcheck 2>/dev/null || true
  common_teardown
}

@test "shell.sh runs shellcheck on shell files" {
  cat > test.sh << 'EOF'
#!/bin/bash
echo "test"
EOF
  chmod +x test.sh
  stub_repeated shellcheck "true"
  
  run --separate-stderr "$LINTERS_DIR/shell.sh"
  
  [ "x$BATS_TEST_COMPLETED" = "x" ] && echo "o:'${output}' e:'${stderr}'"
  assert_success
  assert_output --partial "passed"
}

@test "shell.sh reports when no shell scripts exist" {
  run --separate-stderr "$LINTERS_DIR/shell.sh"
  
  [ "x$BATS_TEST_COMPLETED" = "x" ] && echo "o:'${output}' e:'${stderr}'"
  assert_success
  assert_output --partial "No shell"
}

@test "shell.sh fails when shellcheck finds issues" {
  cat > test.sh << 'EOF'
#!/bin/bash
echo "test"
EOF
  chmod +x test.sh
  stub_repeated shellcheck "exit 1"
  
  run --separate-stderr "$LINTERS_DIR/shell.sh"
  
  [ "x$BATS_TEST_COMPLETED" = "x" ] && echo "o:'${output}' e:'${stderr}'"
  assert_failure
}
