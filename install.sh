#!/bin/bash
# Installs Ralph Gemini into a target project directory.
# Usage: ./install.sh [target_directory]

TARGET_DIR="${1:-.}"

# Ensure target exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory '$TARGET_DIR' does not exist."
    exit 1
fi

# Get absolute path of target
TARGET_DIR=$(cd "$TARGET_DIR" && pwd)

# Get directory of this script (source of Ralph files)
SOURCE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Installing Ralph Gemini to '$TARGET_DIR'..."

# Create specs directory if it doesn't exist
if [ ! -d "$TARGET_DIR/specs" ]; then
    echo "Creating 'specs/' directory..."
    mkdir -p "$TARGET_DIR/specs"
    # Create a placehoder spec to get them started
    echo "# First Feature Spec" > "$TARGET_DIR/specs/01_initial_feature.md"
    echo "" >> "$TARGET_DIR/specs/01_initial_feature.md"
    echo "Describe your first feature requirements here." >> "$TARGET_DIR/specs/01_initial_feature.md"
fi

# Copy files
echo "Copying core files..."
cp "$SOURCE_DIR/loop.sh" "$TARGET_DIR/"
cp "$SOURCE_DIR/PROMPT_plan.md" "$TARGET_DIR/"
cp "$SOURCE_DIR/PROMPT_build.md" "$TARGET_DIR/"

# Don't overwrite AGENTS.md if it exists, as it accumulates project knowledge
if [ -f "$TARGET_DIR/AGENTS.md" ]; then
    echo "Skipping AGENTS.md (already exists)."
else
    cp "$SOURCE_DIR/AGENTS.md" "$TARGET_DIR/"
fi

# Make loop executable
chmod +x "$TARGET_DIR/loop.sh"

# Initialize Git if needed
if [ ! -d "$TARGET_DIR/.git" ]; then
    echo "Initializing git repository..."
    (cd "$TARGET_DIR" && git init && git commit --allow-empty -m "Root commit")
fi

echo "--------------------------------------------------------"
echo "✅ Ralph installed successfully!"
echo ""
echo "Next steps:"
echo "1. CD into your project: cd $TARGET_DIR"
echo "2. Edit 'specs/01_initial_feature.md' with your requirements."
echo "3. Run planning mode: ./loop.sh plan"
echo "--------------------------------------------------------"
