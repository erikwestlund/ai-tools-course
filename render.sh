#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Building the public student repository..."
Rscript scripts/build-student-repo.R

echo "Done."
