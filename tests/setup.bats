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

# =============================================================================
# Update check caching tests
# =============================================================================

@test "setup.sh creates marker file after update check" {
  setup_isolated_home
  local fake_dir="${TEST_DIR}/devtools"
  mkdir -p "$fake_dir"
  
  # Init isolated git repo
  cd "$fake_dir"
  export GIT_CONFIG_NOSYSTEM=1
  export GIT_CONFIG_GLOBAL="${HOME}/.gitconfig"
  git init -q
  git config user.email "test@example.com"
  git config user.name "Test"
  echo "test" > README.md
  git add README.md
  git commit -q -m "init"
  
  # Stub git fetch to succeed
  stub_repeated git 'exit 0'
  
  run "$SCRIPT_DIR/setup.sh" "https://example.com/repo" "$fake_dir"
  
  assert_success
  assert_file_exists "$fake_dir/.last-update-check"
}

@test "setup.sh skips update check if marker file is recent" {
  setup_isolated_home
  local fake_dir="${TEST_DIR}/devtools"
  mkdir -p "$fake_dir"
  
  # Create recent marker file
  touch "$fake_dir/.last-update-check"
  
  # Stub git fetch to fail (should not be called)
  stub_repeated git 'echo "git should not be called"; exit 1'
  
  run "$SCRIPT_DIR/setup.sh" "https://example.com/repo" "$fake_dir"
  
  assert_success
  refute_output --partial "git should not be called"
}

@test "setup.sh checks for updates if marker file is older than 1 hour" {
  setup_isolated_home
  local fake_dir="${TEST_DIR}/devtools"
  mkdir -p "$fake_dir"
  
  # Init isolated git repo
  cd "$fake_dir"
  export GIT_CONFIG_NOSYSTEM=1
  export GIT_CONFIG_GLOBAL="${HOME}/.gitconfig"
  git init -q
  git config user.email "test@example.com"
  git config user.name "Test"
  echo "test" > README.md
  git add README.md
  git commit -q -m "init"
  
  # Create OLD marker file (61 minutes ago)
  touch "$fake_dir/.last-update-check"
  touch -d "61 minutes ago" "$fake_dir/.last-update-check"
  
  run "$SCRIPT_DIR/setup.sh" "https://example.com/repo" "$fake_dir"
  
  # Should have run (git fetch succeeds, updates marker)
  assert_success
  # Marker file should be updated to now
  local marker_age
  marker_age=$(find "$fake_dir/.last-update-check" -mmin +1 2>/dev/null || true)
  assert_equal "$marker_age" ""
}
