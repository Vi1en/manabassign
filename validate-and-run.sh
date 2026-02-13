#!/bin/bash
# Comprehensive validation and test runner

set -e

cd /home/kaif/harbor-work/harbor

echo "========================================="
echo "Harbor Task Validation & Testing"
echo "========================================="
echo ""

# Step 1: Linting
echo "Step 1: Running linting check..."
echo "----------------------------------------"
if uvx ruff check harbor_tasks/word-count-task; then
    echo "✅ Linting passed"
else
    echo "❌ Linting failed"
    exit 1
fi
echo ""

# Step 2: Oracle Test
echo "Step 2: Running Oracle Test (expects 1.000)..."
echo "----------------------------------------"
ORACLE_OUTPUT=$(uv run harbor run --agent oracle --path harbor_tasks/word-count-task --job-name test-oracle 2>&1)
echo "$ORACLE_OUTPUT"
echo ""

# Extract Oracle results
ORACLE_TRIALS=$(echo "$ORACLE_OUTPUT" | grep -oP 'Trials\s+\|\s+\K[0-9]+' | head -1 || echo "0")
ORACLE_ERRORS=$(echo "$ORACLE_OUTPUT" | grep -oP 'Errors\s+\|\s+\K[0-9]+' | head -1 || echo "1")
ORACLE_MEAN=$(echo "$ORACLE_OUTPUT" | grep -oP 'Mean\s+\|\s+\K[0-9.]+' | head -1 || echo "0.000")

echo "Oracle Results:"
echo "  Trials: $ORACLE_TRIALS"
echo "  Errors: $ORACLE_ERRORS"
echo "  Mean: $ORACLE_MEAN"
echo ""

# Step 3: NOP Test
echo "Step 3: Running NOP Test (expects 0.000)..."
echo "----------------------------------------"
NOP_OUTPUT=$(uv run harbor run --agent nop --path harbor_tasks/word-count-task --job-name test-nop 2>&1)
echo "$NOP_OUTPUT"
echo ""

# Extract NOP results
NOP_TRIALS=$(echo "$NOP_OUTPUT" | grep -oP 'Trials\s+\|\s+\K[0-9]+' | head -1 || echo "0")
NOP_ERRORS=$(echo "$NOP_OUTPUT" | grep -oP 'Errors\s+\|\s+\K[0-9]+' | head -1 || echo "1")
NOP_MEAN=$(echo "$NOP_OUTPUT" | grep -oP 'Mean\s+\|\s+\K[0-9.]+' | head -1 || echo "1.000")

echo "NOP Results:"
echo "  Trials: $NOP_TRIALS"
echo "  Errors: $NOP_ERRORS"
echo "  Mean: $NOP_MEAN"
echo ""

# Step 4: Final Summary
echo "========================================="
echo "Final Summary"
echo "========================================="
echo "Oracle:"
echo "  Trials: $ORACLE_TRIALS"
echo "  Errors: $ORACLE_ERRORS"
echo "  Mean: $ORACLE_MEAN"
echo ""
echo "NOP:"
echo "  Trials: $NOP_TRIALS"
echo "  Errors: $NOP_ERRORS"
echo "  Mean: $NOP_MEAN"
echo ""

# Check if results match expected
SUCCESS=true

if [ "$ORACLE_TRIALS" != "1" ]; then
    echo "❌ Oracle Trials should be 1, got $ORACLE_TRIALS"
    SUCCESS=false
fi

if [ "$ORACLE_ERRORS" != "0" ]; then
    echo "❌ Oracle Errors should be 0, got $ORACLE_ERRORS"
    SUCCESS=false
fi

if [ "$ORACLE_MEAN" != "1.000" ]; then
    echo "❌ Oracle Mean should be 1.000, got $ORACLE_MEAN"
    SUCCESS=false
fi

if [ "$NOP_TRIALS" != "1" ]; then
    echo "❌ NOP Trials should be 1, got $NOP_TRIALS"
    SUCCESS=false
fi

if [ "$NOP_ERRORS" != "0" ]; then
    echo "❌ NOP Errors should be 0, got $NOP_ERRORS"
    SUCCESS=false
fi

if [ "$NOP_MEAN" != "0.000" ]; then
    echo "❌ NOP Mean should be 0.000, got $NOP_MEAN"
    SUCCESS=false
fi

if [ "$SUCCESS" = true ]; then
    echo "✅ SUCCESS! All tests passed with expected values!"
    echo "========================================="
    exit 0
else
    echo "❌ Some tests did not meet expected values"
    echo "========================================="
    exit 1
fi

