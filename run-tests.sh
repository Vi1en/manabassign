#!/bin/bash
# Run Harbor validation tests

cd /home/kaif/harbor-work/harbor

echo "========================================="
echo "Running Oracle Test..."
echo "========================================="
uv run harbor run --agent oracle --path harbor_tasks/word-count-task --job-name test-oracle

echo ""
echo "========================================="
echo "Running NOP Test..."
echo "========================================="
uv run harbor run --agent nop --path harbor_tasks/word-count-task --job-name test-nop

echo ""
echo "========================================="
echo "Tests Complete!"
echo "========================================="

