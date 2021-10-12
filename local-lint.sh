#!/bin/sh
markdownlint -c .github/workflows/config/markdown_lint_config.yml . && \
  yamllint .