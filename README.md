# Ralph Gemini

This directory contains a port of the Ralph Wiggum agentic loop, adapted for use with the Gemini CLI.

## Prerequisites

1.  **Git**: Ensure you are in a git repository.
2.  **Gemini CLI**: You must have a command-line tool named `gemini` that accepts prompts via stdin.
    *   If your tool is named differently (e.g., `llm`, `gcloud`), edit `loop.sh` to use the correct command.
    *   Ensure it is authenticated and ready to use.

## Installation (New Projects)

To use Ralph in a new project, use the included `install.sh` script to copy the necessary files.

```bash
# From your new project directory:
/path/to/how-to-ralph-wiggum/ralph-gemini/install.sh .
```

This will:
1.  Copy `loop.sh`, `PROMPT_*.md`, and `AGENTS.md` to your root.
2.  Create a `specs/` directory if missing.
3.  Make the script executable.

### Pro Tip: Create an Alias

To make this available everywhere, add an alias to your shell configuration (e.g., `~/.zshrc`):

```bash
alias ralph-init="/absolute/path/to/how-to-ralph-wiggum/ralph-gemini/install.sh ."
```

Then you can simply run `ralph-init` in any new project folder!

## Setup (Manual)

If you are setting this up manually or editing the template:

1.  Make the loop script executable:
    ```bash
    chmod +x loop.sh
    ```

2.  Initialize your `AGENTS.md`:
    *   Edit `AGENTS.md` to include the specific build and test commands for your project.

## Usage

The loop operates in two modes: **Planning** and **Building**.

### 1. Planning Mode

Generates or updates the `IMPLEMENTATION_PLAN.md` based on your specs and codebase.

```bash
./loop.sh plan
```

### 2. Building Mode

Executes the plan, implementing features one by one, running tests, and committing changes.

```bash
# Run indefinitely until stopped (Ctrl+C)
./loop.sh

# Run for a specific number of iterations
./loop.sh 5
```

### YOLO Mode (Autonomy)

To run in "YOLO mode" (skipping permission checks for fully autonomous operation), edit `loop.sh` to set the appropriate flag for your Gemini CLI (typically `-y`):

```bash
# In loop.sh
GEMINI_FLAGS="-y" # Example flag
```


## Directory Structure

*   `loop.sh`: The main driver script.
*   `PROMPT_plan.md`: The system prompt for planning mode.
*   `PROMPT_build.md`: The system prompt for building mode.
*   `AGENTS.md`: Operational knowledge base for the agent.

## Workflow

1.  Define your requirements in `specs/*.md` files (create this directory if it doesn't exist).
2.  Run **Planning Mode** to generate `IMPLEMENTATION_PLAN.md`.
3.  Review the plan.
## Native Sandbox & Security

The Gemini CLI has a built-in sandbox feature, which is the preferred way to run Ralph safely.

### Using `--sandbox`

The `loop.sh` script is configured to use `gemini --sandbox -y` by default. This ensures that:

1.  **Tool Execution**: Any potentially dangerous tools (file edits, shell commands) are executed inside a secure Docker container managed by the Gemini CLI.
2.  **Project Access**: The current directory is typically mounted into the sandbox so the agent can work on your code, but it cannot access the rest of your system.
3.  **Autonomy**: The `-y` flag (YOLO mode) allows the loop to run without constant manual approval.

### Configuration

You can override the flags in `loop.sh` or by setting the environment variable:

```bash
# Disable sandbox (NOT RECOMMENDED)
GEMINI_FLAGS="-y" ./loop.sh
```

### Docker Requirements

Ensure you have Docker installed and running, as `gemini --sandbox` relies on it.


