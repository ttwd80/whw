#!/bin/sh
markdownlint -c .github/workflows/markdown_lint_config.yml . && \
  yamllint .