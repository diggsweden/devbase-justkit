<!--
SPDX-FileCopyrightText: 2025 Digg - Agency for Digital Government

SPDX-License-Identifier: CC0-1.0
-->

# devbase-justkit

[![Tag](https://img.shields.io/github/v/tag/diggsweden/devbase-justkit?style=for-the-badge&color=green)](https://github.com/diggsweden/devbase-justkit/tags)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue?style=for-the-badge)](LICENSE)
[![REUSE](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fapi.reuse.software%2Fstatus%2Fgithub.com%2Fdiggsweden%2Fdevbase-justkit&query=status&style=for-the-badge&label=REUSE&color=lightblue)](https://api.reuse.software/info/github.com/diggsweden/devbase-justkit)

[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/diggsweden/devbase-justkit/badge?style=for-the-badge)](https://scorecard.dev/viewer/?uri=github.com/diggsweden/devbase-justkit)

Shared linting and development tooling for just/mise projects.

## Full Examples

See `examples/` folder for complete, ready-to-use justfiles:

- [`examples/java-justfile`](examples/java-justfile) - Java/Maven project

## Quick Start

Add to your project's justfile:

```just
devtools_repo := "https://github.com/diggsweden/devbase-justkit"
devtools_dir := env("XDG_DATA_HOME", env("HOME") + "/.local/share") + "/devbase-justkit"
lint := devtools_dir + "/linters"
colors := devtools_dir + "/utils/colors.sh"

# Setup devtools (clone or update)
setup-devtools:
    @{{devtools_dir}}/scripts/setup.sh "{{devtools_repo}}" "{{devtools_dir}}"

# Run all linters
lint-all: lint-commits lint-secrets lint-yaml lint-markdown lint-shell lint-shell-fmt lint-actions lint-license

lint-commits:
    @{{lint}}/commits.sh

lint-secrets:
    @{{lint}}/secrets.sh

lint-yaml:
    @{{lint}}/yaml.sh check

lint-yaml-fix:
    @{{lint}}/yaml.sh fix

lint-markdown:
    @{{lint}}/markdown.sh check

lint-markdown-fix:
    @{{lint}}/markdown.sh fix

lint-shell:
    @{{lint}}/shell.sh

lint-shell-fmt:
    @{{lint}}/shell-fmt.sh check

lint-shell-fmt-fix:
    @{{lint}}/shell-fmt.sh fix

lint-actions:
    @{{lint}}/github-actions.sh

lint-license:
    @{{lint}}/license.sh
```

Then run:

```bash
just setup-devtools
just lint-all
```

## Available Linters

| Recipe | Tool | Skips when |
|--------|------|------------|
| `lint-commits` | conform | No commits to check |
| `lint-secrets` | gitleaks | Never |
| `lint-yaml` | yamlfmt | Never |
| `lint-markdown` | rumdl | Never |
| `lint-shell` | shellcheck | No .sh files |
| `lint-shell-fmt` | shfmt | No .sh files |
| `lint-actions` | actionlint | No .github/workflows/ |
| `lint-license` | reuse | Never |

### Java Linters

| Recipe | Tool | Description |
|--------|------|-------------|
| `lint-java` | maven | Run all (checkstyle + pmd + spotbugs) |
| `lint-java-checkstyle` | checkstyle | Style checks |
| `lint-java-pmd` | pmd | Static analysis |
| `lint-java-spotbugs` | spotbugs | Bug detection |
| `lint-java-fmt` | formatter | Check formatting |
| `lint-java-fmt-fix` | formatter | Fix formatting |
| `test-java` | maven | Run tests (mvn verify) |

## Customizing lint-all

Override `lint-all` in your project's justfile to tailor linting to your needs.

### Java/Maven Project

```just
java_lint := devtools_dir + "/linters/java"

lint-all: lint-commits lint-secrets lint-yaml lint-markdown lint-actions lint-license lint-java

lint-java:
    @{{java_lint}}/lint.sh
```

See [`examples/java-justfile`](examples/java-justfile) for full example with checkstyle, pmd, spotbugs, formatting and tests.

### Node/TypeScript Project

```just
lint-all: lint-commits lint-secrets lint-yaml lint-markdown lint-actions lint-license lint-ts

lint-ts:
    #!/usr/bin/env bash
    source "{{colors}}"
    just_header "TypeScript Linting" "npm run lint"
    npm run lint
    just_success "TypeScript linting passed"
```

### Go Project

```just
lint-all: lint-commits lint-secrets lint-yaml lint-markdown lint-shell lint-shell-fmt lint-actions lint-license lint-go

lint-go:
    #!/usr/bin/env bash
    source "{{colors}}"
    just_header "Go Linting" "golangci-lint run"
    go vet ./...
    golangci-lint run
    just_success "Go linting passed"
```

### Python Project

```just
lint-all: lint-commits lint-secrets lint-yaml lint-markdown lint-actions lint-license lint-python

lint-python:
    #!/usr/bin/env bash
    source "{{colors}}"
    just_header "Python Linting" "ruff check"
    ruff check .
    ruff format --check .
    just_success "Python linting passed"
```

### Rust Project

```just
lint-all: lint-commits lint-secrets lint-yaml lint-markdown lint-actions lint-license lint-rust

lint-rust:
    #!/usr/bin/env bash
    source "{{colors}}"
    just_header "Rust Linting" "cargo clippy"
    cargo fmt --check
    cargo clippy -- -D warnings
    just_success "Rust linting passed"
```

### Minimal (CI-focused)

```just
lint-all: lint-commits lint-secrets lint-license
```

## Helper Functions

Source `colors.sh` in bash recipes for consistent output:

```just
my-recipe:
    #!/usr/bin/env bash
    source "{{colors}}"
    just_header "My Task" "some command"
    just_run "some command" "Task description"
    just_success "Task completed"
```

Available functions:

| Function | Description |
|----------|-------------|
| `just_header "Title" "cmd"` | Cyan header with dim command |
| `just_run "cmd" "desc"` | Run command, show output only on failure |
| `just_success "msg"` | Green ✓ message |
| `just_error "msg"` | Red ✗ message |
| `just_warn "msg"` | Yellow ! message |

## Directory Structure

```
devbase-justkit/
├── linters/
│   ├── java/
│   │   ├── checkstyle.sh
│   │   ├── format.sh
│   │   ├── lint.sh
│   │   ├── pmd.sh
│   │   ├── spotbugs.sh
│   │   └── test.sh
│   ├── commits.sh
│   ├── github-actions.sh
│   ├── license.sh
│   ├── markdown.sh
│   ├── secrets.sh
│   ├── shell-fmt.sh
│   ├── shell.sh
│   └── yaml.sh
├── scripts/
│   ├── check-tools.sh
│   ├── setup.sh
│   └── verify.sh
├── utils/
│   └── colors.sh
├── examples/
│   └── java-justfile
├── .mise.toml
├── justfile
└── README.md
```

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT). Documentation and configuration files are licensed under [CC0-1.0](https://creativecommons.org/publicdomain/zero/1.0/).

See the SPDX headers in each file for details. This project is [REUSE](https://reuse.software/) compliant.
