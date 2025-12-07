#!/usr/bin/env bats

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

# Tests for base linter scripts

bats_require_minimum_version 1.13.0

load "${BATS_TEST_DIRNAME}/libs/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-file/load.bash"

setup() {
  TEST_DIR="$(temp_make)"
  export TEST_DIR
  export LINTERS_DIR="${BATS_TEST_DIRNAME}/../linters"
  cd "$TEST_DIR"
  git init -q
}

teardown() {
  temp_del "$TEST_DIR"
}

@test "yaml.sh exists and is executable" {
  assert_file_exists "$LINTERS_DIR/yaml.sh"
  assert_file_executable "$LINTERS_DIR/yaml.sh"
}

@test "yaml.sh check mode runs without errors on valid YAML" {
  cat > test.yaml << 'EOF'
key: value
EOF
  
  run -0 "$LINTERS_DIR/yaml.sh" check
  
  assert_success
  assert_output --partial "YAML"
}

@test "markdown.sh exists and is executable" {
  assert_file_exists "$LINTERS_DIR/markdown.sh"
  assert_file_executable "$LINTERS_DIR/markdown.sh"
}

@test "markdown.sh check mode runs on markdown files" {
  cat > test.md << 'EOF'
# Test
EOF
  
  run "$LINTERS_DIR/markdown.sh" check
  
  assert_output --partial "MARKDOWN"
}

@test "shell.sh exists and is executable" {
  assert_file_exists "$LINTERS_DIR/shell.sh"
  assert_file_executable "$LINTERS_DIR/shell.sh"
}

@test "shell.sh runs shellcheck when shell files exist" {
  cat > test.sh << 'EOF'
#!/bin/bash
echo "test"
EOF
  chmod +x test.sh
  
  run "$LINTERS_DIR/shell.sh"
  
  assert_output --partial "SHELL"
}

@test "shell-fmt.sh exists and is executable" {
  assert_file_exists "$LINTERS_DIR/shell-fmt.sh"
  assert_file_executable "$LINTERS_DIR/shell-fmt.sh"
}

@test "commits.sh exists and is executable" {
  assert_file_exists "$LINTERS_DIR/commits.sh"
  assert_file_executable "$LINTERS_DIR/commits.sh"
}

@test "secrets.sh exists and is executable" {
  assert_file_exists "$LINTERS_DIR/secrets.sh"
  assert_file_executable "$LINTERS_DIR/secrets.sh"
}

@test "github-actions.sh exists and is executable" {
  assert_file_exists "$LINTERS_DIR/github-actions.sh"
  assert_file_executable "$LINTERS_DIR/github-actions.sh"
}

@test "license.sh exists and is executable" {
  assert_file_exists "$LINTERS_DIR/license.sh"
  assert_file_executable "$LINTERS_DIR/license.sh"
}

@test "container.sh exists and is executable" {
  assert_file_exists "$LINTERS_DIR/container.sh"
  assert_file_executable "$LINTERS_DIR/container.sh"
}

@test "xml.sh exists and is executable" {
  assert_file_exists "$LINTERS_DIR/xml.sh"
  assert_file_executable "$LINTERS_DIR/xml.sh"
}
