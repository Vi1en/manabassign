#!/bin/bash
# Validation script for word-count-task

set -e

echo "========================================="
echo "Running Harbor Task Validation Tests"
echo "========================================="
echo ""

# Navigate to harbor root
cd /home/kaif/harbor-work/harbor

echo "1. Running Oracle Test (expects 1.0)..."
echo "----------------------------------------"
uv run harbor run --agent oracle --path harbor_tasks/word-count-task --job-name test-oracle
echo ""

echo "2. Running NOP Test (expects 0.0)..."
echo "----------------------------------------"
uv run harbor run --agent nop --path harbor_tasks/word-count-task --job-name test-nop
echo ""

echo "3. Running Linting Check..."
echo "----------------------------------------"
uvx ruff check harbor_tasks/word-count-task
echo ""

echo "========================================="
echo "Validation Complete!"
echo "========================================="

