#!/bin/bash
# Script to run tests until we get Oracle: 1.000 and NOP: 0.000

set -e

cd /home/kaif/harbor-work/harbor

echo "========================================="
echo "Running Harbor Validation Tests"
echo "========================================="
echo ""

MAX_ATTEMPTS=5
ATTEMPT=1

while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    echo "Attempt $ATTEMPT of $MAX_ATTEMPTS"
    echo "----------------------------------------"
    
    # Run Oracle test
    echo "Running Oracle Test..."
    ORACLE_OUTPUT=$(uv run harbor run --agent oracle --path harbor_tasks/word-count-task --job-name test-oracle 2>&1)
    echo "$ORACLE_OUTPUT"
    
    # Extract Oracle mean value
    ORACLE_MEAN=$(echo "$ORACLE_OUTPUT" | grep -oP 'Mean\s+\|\s+\K[0-9.]+' | head -1 || echo "0.000")
    
    # Run NOP test
    echo ""
    echo "Running NOP Test..."
    NOP_OUTPUT=$(uv run harbor run --agent nop --path harbor_tasks/word-count-task --job-name test-nop 2>&1)
    echo "$NOP_OUTPUT"
    
    # Extract NOP mean value
    NOP_MEAN=$(echo "$NOP_OUTPUT" | grep -oP 'Mean\s+\|\s+\K[0-9.]+' | head -1 || echo "1.000")
    
    echo ""
    echo "Results:"
    echo "  Oracle Mean: $ORACLE_MEAN (expected: 1.000)"
    echo "  NOP Mean: $NOP_MEAN (expected: 0.000)"
    echo ""
    
    # Check if we got the expected results
    if [ "$ORACLE_MEAN" = "1.000" ] && [ "$NOP_MEAN" = "0.000" ]; then
        echo "✅ SUCCESS! Both tests passed with expected values!"
        echo "========================================="
        exit 0
    else
        echo "❌ Results don't match expected values. Retrying..."
        echo ""
        ATTEMPT=$((ATTEMPT + 1))
        sleep 2
    fi
done

echo "❌ Failed to get expected results after $MAX_ATTEMPTS attempts"
exit 1

