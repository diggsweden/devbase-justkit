#!/usr/bin/env bats

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

# Tests for scripts/verify.sh

bats_require_minimum_version 1.13.0

load "${BATS_TEST_DIRNAME}/libs/bats-support/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-assert/load.bash"
load "${BATS_TEST_DIRNAME}/libs/bats-file/load.bash"

setup() {
  TEST_DIR="$(temp_make)"
  export TEST_DIR
  export SCRIPT_DIR="${BATS_TEST_DIRNAME}/../scripts"
  export DEVBASE_DIR="${BATS_TEST_DIRNAME}/.."
  cd "$TEST_DIR"
  git init -q
}

teardown() {
  temp_del "$TEST_DIR"
}

@test "verify.sh runs base linters" {
  cat > justfile << 'EOF'
# SPDX-FileCopyrightText: 2025 Test
# SPDX-License-Identifier: MIT
default:
    @echo "test"
EOF
  
  run "$SCRIPT_DIR/verify.sh"
  
  assert_output --partial "Commits"
  assert_output --partial "YAML"
  assert_output --partial "Markdown"
  assert_output --partial "Shell Scripts"
  assert_output --partial "License"
}

@test "verify.sh shows summary table with proper format" {
  cat > justfile << 'EOF'
# SPDX-FileCopyrightText: 2025 Test
# SPDX-License-Identifier: MIT
default:
    @echo "test"
EOF
  
  run "$SCRIPT_DIR/verify.sh"
  
  assert_output --partial "Check"
  assert_output --partial "Tool"
  assert_line --partial "-----"
  assert_output --partial "Total:"
}

@test "verify.sh exits with failure when linters fail" {
  cat > justfile << 'EOF'
# SPDX-FileCopyrightText: 2025 Test
# SPDX-License-Identifier: MIT
lint-commits:
    @exit 1
EOF
  
  run -1 "$SCRIPT_DIR/verify.sh"
  
  assert_failure
  assert_output --partial "failed"
}

@test "verify.sh continues after linter failures" {
  cat > justfile << 'EOF'
# SPDX-FileCopyrightText: 2025 Test
# SPDX-License-Identifier: MIT
lint-commits:
    @exit 1
EOF
  
  run -1 "$SCRIPT_DIR/verify.sh"
  
  assert_failure
  # All base linters should still appear in summary
  assert_output --partial "Total:"
  assert_output --partial "passed"
  assert_output --partial "failed"
}

@test "verify.sh shows pass/fail/skipped/n/a counts in summary" {
  cat > justfile << 'EOF'
# SPDX-FileCopyrightText: 2025 Test
# SPDX-License-Identifier: MIT
default:
    @echo "test"
EOF
  
  run "$SCRIPT_DIR/verify.sh"
  
  # Summary should show counts
  assert_output --regexp "[0-9]+ passed"
  assert_output --regexp "\(of [0-9]+\)"
}
