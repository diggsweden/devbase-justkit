#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: MIT

# Install BATS helper libraries for testing

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LIBS_DIR="${SCRIPT_DIR}/libs"

mkdir -p "$LIBS_DIR"

# Clone or update bats-support
if [[ -d "${LIBS_DIR}/bats-support" ]]; then
  echo "Updating bats-support..."
  git -C "${LIBS_DIR}/bats-support" pull --quiet
else
  echo "Installing bats-support..."
  git clone --depth 1 --branch v0.3.0 https://github.com/bats-core/bats-support.git "${LIBS_DIR}/bats-support"
fi

# Clone or update bats-assert
if [[ -d "${LIBS_DIR}/bats-assert" ]]; then
  echo "Updating bats-assert..."
  git -C "${LIBS_DIR}/bats-assert" pull --quiet
else
  echo "Installing bats-assert..."
  git clone --depth 1 --branch v2.1.0 https://github.com/bats-core/bats-assert.git "${LIBS_DIR}/bats-assert"
fi

# Clone or update bats-file
if [[ -d "${LIBS_DIR}/bats-file" ]]; then
  echo "Updating bats-file..."
  git -C "${LIBS_DIR}/bats-file" pull --quiet
else
  echo "Installing bats-file..."
  git clone --depth 1 --branch v0.4.0 https://github.com/bats-core/bats-file.git "${LIBS_DIR}/bats-file"
fi

echo "✓ BATS libraries installed in ${LIBS_DIR}"
