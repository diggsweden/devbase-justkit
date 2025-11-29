# SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government
#
# SPDX-License-Identifier: CC0-1.0

# Quality checks and automation for devbase-justkit
# Run 'just' to see available commands

lint := "./linters"
colors := "./utils/colors.sh"

# ==================================================================================== #
# DEFAULT - Show available recipes
# ==================================================================================== #

# Display available recipes
default:
    @printf "\033[1;36m DevBase JustKit\033[0m\n"
    @printf "\n"
    @printf "Quick start: \033[1;32mjust verify\033[0m | \033[1;34mjust lint-all\033[0m | \033[1;35mjust lint-fix\033[0m\n"
    @printf "\n"
    @just --list --unsorted

# ==================================================================================== #
# VERIFY - Quality assurance
# ==================================================================================== #

# ▪ Run all linters with summary
[group('verify')]
verify:
    @./scripts/verify.sh

# ==================================================================================== #
# LINT - Code quality checks
# ==================================================================================== #

# ▪ Run all linters
[group('lint')]
lint-all: lint-secrets lint-yaml lint-shell lint-shell-fmt lint-license
    #!/usr/bin/env bash
    source "{{colors}}"
    just_success "All linting checks completed"

# Scan for secrets (gitleaks)
[group('lint')]
lint-secrets:
    @{{lint}}/secrets.sh

# Lint YAML files (yamlfmt)
[group('lint')]
lint-yaml:
    @{{lint}}/yaml.sh check

# Lint shell scripts (shellcheck)
[group('lint')]
lint-shell:
    @{{lint}}/shell.sh

# Check shell formatting (shfmt)
[group('lint')]
lint-shell-fmt:
    @{{lint}}/shell-fmt.sh check

# Check license compliance (reuse)
[group('lint')]
lint-license:
    @{{lint}}/license.sh

# ==================================================================================== #
# LINT-FIX - Auto-fix linting violations
# ==================================================================================== #

# ▪ Fix all auto-fixable issues
[group('lint-fix')]
lint-fix: lint-yaml-fix lint-shell-fmt-fix
    #!/usr/bin/env bash
    source "{{colors}}"
    just_success "All auto-fixes completed"

# Fix YAML formatting
[group('lint-fix')]
lint-yaml-fix:
    @{{lint}}/yaml.sh fix

# Fix shell formatting
[group('lint-fix')]
lint-shell-fmt-fix:
    @{{lint}}/shell-fmt.sh fix
