#!/usr/bin/env bats

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

# Tests for Node linter scripts

bats_require_minimum_version 1.13.0

load "${BATS_TEST_DIRNAME}/libs/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-file/load.bash"

setup() {
  TEST_DIR="$(temp_make)"
  export TEST_DIR
  export NODE_LINTERS="${BATS_TEST_DIRNAME}/../linters/node"
  cd "$TEST_DIR"
}

teardown() {
  temp_del "$TEST_DIR"
}

@test "lint.sh exists and is executable" {
  assert_file_exists "$NODE_LINTERS/lint.sh"
  assert_file_executable "$NODE_LINTERS/lint.sh"
}

@test "eslint.sh exists and is executable" {
  assert_file_exists "$NODE_LINTERS/eslint.sh"
  assert_file_executable "$NODE_LINTERS/eslint.sh"
}

@test "eslint.sh skips when no package.json present" {
  run -0 "$NODE_LINTERS/eslint.sh"
  
  assert_success
  assert_output --partial "package.json"
}

@test "eslint.sh skips when eslint not in package.json" {
  cat > package.json << 'EOF'
{
  "name": "test",
  "version": "1.0.0"
}
EOF
  
  run -0 "$NODE_LINTERS/eslint.sh"
  
  assert_success
  assert_output --partial "ESLint"
}

@test "eslint.sh requires npx when configured" {
  if command -v npx >/dev/null 2>&1; then
    skip "npx is installed, cannot test missing npx behavior"
  fi
  
  cat > package.json << 'EOF'
{
  "name": "test",
  "devDependencies": {
    "eslint": "^8.0.0"
  }
}
EOF
  
  run -1 "$NODE_LINTERS/eslint.sh"
  
  assert_failure
  assert_output --partial "npx not found"
}

@test "format.sh exists and is executable" {
  assert_file_exists "$NODE_LINTERS/format.sh"
  assert_file_executable "$NODE_LINTERS/format.sh"
}

@test "format.sh skips when no package.json present" {
  run -0 "$NODE_LINTERS/format.sh" check
  
  assert_success
  assert_output --partial "package.json"
}

@test "types.sh exists and is executable" {
  assert_file_exists "$NODE_LINTERS/types.sh"
  assert_file_executable "$NODE_LINTERS/types.sh"
}

@test "types.sh skips when no package.json present" {
  run -0 "$NODE_LINTERS/types.sh"
  
  assert_success
  assert_output --partial "package.json"
}
