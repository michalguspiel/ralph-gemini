#!/bin/bash
# Usage: ./loop.sh [plan] [max_iterations]
# Examples:
#   ./loop.sh              # Build mode, unlimited iterations
#   ./loop.sh 20           # Build mode, max 20 iterations
#   ./loop.sh plan         # Plan mode, unlimited iterations
#   ./loop.sh plan 5       # Plan mode, max 5 iterations

# Parse arguments
if [ "$1" = "plan" ]; then
    # Plan mode
    MODE="plan"
    PROMPT_FILE="PROMPT_plan.md"
    MAX_ITERATIONS=${2:-0}
elif [[ "$1" =~ ^[0-9]+$ ]]; then
    # Build mode with max iterations
    MODE="build"
    PROMPT_FILE="PROMPT_build.md"
    MAX_ITERATIONS=$1
else
    # Build mode, unlimited (no arguments or invalid input)
    MODE="build"
    PROMPT_FILE="PROMPT_build.md"
    MAX_ITERATIONS=0
fi

# Trap Ctrl+C (SIGINT) to ensure the loop exits immediately
trap "echo 'Exiting loop...'; exit" INT

ITERATION=0
CURRENT_BRANCH=$(git branch --show-current)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Mode:   $MODE"
echo "Prompt: $PROMPT_FILE"
echo "Branch: $CURRENT_BRANCH"
[ $MAX_ITERATIONS -gt 0 ] && echo "Max:    $MAX_ITERATIONS iterations"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Verify prompt file exists
if [ ! -f "$PROMPT_FILE" ]; then
    echo "Error: $PROMPT_FILE not found"
    exit 1
fi

while true; do
    if [ $MAX_ITERATIONS -gt 0 ] && [ $ITERATION -ge $MAX_ITERATIONS ]; then
        echo "Reached max iterations: $MAX_ITERATIONS"
        break
    fi

    # Run Ralph iteration with selected prompt
    # Adapted for Gemini CLI
    # Assumes 'gemini' command takes input from stdin.
    # We use the built-in --sandbox for safety and -y for autonomy (YOLO mode).
    # -p argument is not needed if piping via stdin, but checks your specific CLI version.
    
    # "Native Ralph" mode: Sandbox enabled, auto-confirm enabled.
    GEMINI_FLAGS=${GEMINI_FLAGS:-"--sandbox -y"}

    echo "Running iteration $ITERATION..."
    
    # We pass the prompt as a positional argument to the CLI.
    gemini $GEMINI_FLAGS "$(cat "$PROMPT_FILE")" 

    # Push changes after each iteration
    # Only push if we have a remote configured
    if git remote | grep -q "^origin$"; then
        git push origin "$CURRENT_BRANCH" || {
            echo "Failed to push. Creating remote branch..."
            git push -u origin "$CURRENT_BRANCH"
        }
    else
        echo "Git push skipped: No 'origin' remote configured."
        echo "Tip: Add a remote with: git remote add origin <url>"
    fi

    ITERATION=$((ITERATION + 1))
    echo -e "\n\n======================== LOOP $ITERATION ========================\n"
done
