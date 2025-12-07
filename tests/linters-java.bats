#!/usr/bin/env bats

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

# Tests for Java linter scripts

bats_require_minimum_version 1.13.0

load "${BATS_TEST_DIRNAME}/libs/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-file/load.bash"

setup() {
  TEST_DIR="$(temp_make)"
  export TEST_DIR
  export JAVA_LINTERS="${BATS_TEST_DIRNAME}/../linters/java"
  cd "$TEST_DIR"
}

teardown() {
  temp_del "$TEST_DIR"
}

@test "lint.sh exists and is executable" {
  assert_file_exists "$JAVA_LINTERS/lint.sh"
  assert_file_executable "$JAVA_LINTERS/lint.sh"
}

@test "lint.sh skips when no pom.xml present" {
  run -0 "$JAVA_LINTERS/lint.sh"
  
  assert_success
  assert_output --partial "No pom.xml found"
}

@test "lint.sh requires mvn when pom.xml exists" {
  if command -v mvn >/dev/null 2>&1; then
    skip "Maven is installed, cannot test missing mvn behavior"
  fi
  
  cat > pom.xml << 'EOF'
<project>
  <modelVersion>4.0.0</modelVersion>
</project>
EOF
  
  run -1 "$JAVA_LINTERS/lint.sh"
  
  assert_failure
  assert_output --partial "mvn not found"
}

@test "checkstyle.sh exists and is executable" {
  assert_file_exists "$JAVA_LINTERS/checkstyle.sh"
  assert_file_executable "$JAVA_LINTERS/checkstyle.sh"
}

@test "checkstyle.sh skips when no pom.xml present" {
  run -0 "$JAVA_LINTERS/checkstyle.sh"
  
  assert_success
  assert_output --partial "No pom.xml found"
}

@test "pmd.sh exists and is executable" {
  assert_file_exists "$JAVA_LINTERS/pmd.sh"
  assert_file_executable "$JAVA_LINTERS/pmd.sh"
}

@test "spotbugs.sh exists and is executable" {
  assert_file_exists "$JAVA_LINTERS/spotbugs.sh"
  assert_file_executable "$JAVA_LINTERS/spotbugs.sh"
}

@test "format.sh exists and is executable" {
  assert_file_exists "$JAVA_LINTERS/format.sh"
  assert_file_executable "$JAVA_LINTERS/format.sh"
}

@test "test.sh exists and is executable" {
  assert_file_exists "$JAVA_LINTERS/test.sh"
  assert_file_executable "$JAVA_LINTERS/test.sh"
}
