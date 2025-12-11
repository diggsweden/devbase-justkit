#!/usr/bin/env bash
# shellcheck disable=SC2016,SC2154,SC2164,SC2268
# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
# SPDX-License-Identifier: MIT
#
# Shared test helper functions for BATS tests
#
# Shellcheck disabled:
#   SC2016 - Expressions don't expand in single quotes (intentional in mock scripts)
#   SC2154 - Variables like $output/$stderr are set by bats, not this script
#   SC2164 - cd without || exit is fine in test helpers (bats handles failures)
#   SC2268 - x-prefix in comparisons is a common bats pattern for empty checks

# =============================================================================
# Safe Temp Directory Cleanup
# =============================================================================

# Safely delete a temp directory, handling git's write-protected objects
# This wraps temp_del but makes files writable first to avoid interactive prompts
# SAFETY: Only deletes directories under /tmp or $BATS_TMPDIR
# Usage: safe_temp_del <path>
safe_temp_del() {
  local path="$1"
  [[ -z "$path" ]] && return 0
  [[ ! -d "$path" ]] && return 0

  # Resolve to absolute path
  local abs_path
  abs_path="$(cd "$path" 2>/dev/null && pwd)" || return 0

  # SAFETY: Only allow deletion in /tmp or BATS_TMPDIR
  local allowed_base="${BATS_TMPDIR:-/tmp}"
  if [[ "$abs_path" != /tmp/* && "$abs_path" != "$allowed_base"/* ]]; then
    echo "ERROR: safe_temp_del refuses to delete '$abs_path' - not in /tmp or BATS_TMPDIR" >&2
    return 1
  fi

  # Extra safety: refuse to delete if path is too short (e.g., /tmp itself)
  if [[ "${#abs_path}" -lt 10 ]]; then
    echo "ERROR: safe_temp_del refuses to delete '$abs_path' - path too short" >&2
    return 1
  fi

  # Make all files writable to avoid rm prompting on git objects
  chmod -R u+w "$abs_path" 2>/dev/null || true
  temp_del "$abs_path"
}

# =============================================================================
# Git Repository Setup Helpers
# =============================================================================

# Initialize a minimal git repository for testing
# Usage: init_git_repo
init_git_repo() {
  git init -q
  git config user.email "test@example.com"
  git config user.name "Test User"
  echo "initial" >file.txt
  git add file.txt
  git commit -q -m "Initial commit"
}

# Initialize git repo with isolated HOME and config
# Usage: init_isolated_git_repo
init_isolated_git_repo() {
  export HOME="$TEST_DIR/home"
  export GIT_CONFIG_NOSYSTEM=1
  export GIT_CONFIG_GLOBAL="$TEST_DIR/home/.gitconfig"
  mkdir -p "$HOME"
  init_git_repo
}

# =============================================================================
# Debug Helpers
# =============================================================================

# Standard debug output for failed tests
# Usage: debug_output (call after 'run' command)
debug_output() {
  [ "x$BATS_TEST_COMPLETED" = "x" ] && echo "o:'${output}' e:'${stderr}'"
}

# =============================================================================
# Mock Helpers
# =============================================================================

# Create repeated stub that always returns the same result
# Usage: stub_repeated <command> <behavior>
stub_repeated() {
  local cmd="$1"
  local behavior="$2"

  mkdir -p "${TEST_DIR}/bin"
  cat >"${TEST_DIR}/bin/${cmd}" <<SCRIPT
#!/usr/bin/env bash
${behavior}
SCRIPT
  chmod +x "${TEST_DIR}/bin/${cmd}"
  export PATH="${TEST_DIR}/bin:${PATH}"
}
