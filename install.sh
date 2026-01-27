#!/bin/bash
# KnowzCode Shell Installer
# Installs KnowzCode framework without requiring Claude Code commands
#
# Usage:
#   ./install.sh                        # Install to current directory
#   ./install.sh --target /path/to/dir  # Install to specific directory
#   ./install.sh --global               # Install commands to ~/.claude/
#   ./install.sh --force                # Overwrite existing installation

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
TARGET_DIR=""
GLOBAL_INSTALL=false
FORCE_INSTALL=false
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Print colored output
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Show usage
show_usage() {
    cat << EOF
KnowzCode Installer

Usage:
    ./install.sh [OPTIONS]

Options:
    --target <path>   Install to specific directory (default: current directory)
    --global          Install commands to ~/.claude/ (framework files still go to target)
    --force           Overwrite existing installation without prompting
    -h, --help        Show this help message

Examples:
    # Install to current directory
    ./install.sh

    # Install to a specific project
    ./install.sh --target /path/to/your/project

    # Global commands + local framework
    ./install.sh --global --target /path/to/your/project

    # Force reinstall
    ./install.sh --force --target /path/to/your/project

EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --target)
                TARGET_DIR="$2"
                shift 2
                ;;
            --global)
                GLOBAL_INSTALL=true
                shift
                ;;
            --force)
                FORCE_INSTALL=true
                shift
                ;;
            -h|--help)
                show_usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_usage
                exit 1
                ;;
        esac
    done

    # Default target to current directory if not specified
    if [[ -z "$TARGET_DIR" ]]; then
        TARGET_DIR="$(pwd)"
    fi

    # Resolve to absolute path
    TARGET_DIR="$(cd "$TARGET_DIR" 2>/dev/null && pwd)" || {
        print_error "Target directory does not exist: $TARGET_DIR"
        exit 1
    }
}

# Validate source files exist
validate_source() {
    print_info "Validating source files..."

    if [[ ! -d "$SCRIPT_DIR/claude" ]]; then
        print_error "Source directory 'claude/' not found in $SCRIPT_DIR"
        print_error "Please run this script from the KnowzCode template directory."
        exit 1
    fi

    if [[ ! -d "$SCRIPT_DIR/knowzcode" ]]; then
        print_error "Source directory 'knowzcode/' not found in $SCRIPT_DIR"
        print_error "Please run this script from the KnowzCode template directory."
        exit 1
    fi

    print_success "Source files validated"
}

# Check for existing installation
check_existing() {
    local claude_dir="$1"
    local knowzcode_dir="$TARGET_DIR/knowzcode"

    if [[ -d "$claude_dir/commands" ]] || [[ -d "$claude_dir/agents" ]] || [[ -d "$knowzcode_dir" ]]; then
        if [[ "$FORCE_INSTALL" != true ]]; then
            print_warning "KnowzCode appears to already be installed at:"
            [[ -d "$claude_dir/commands" ]] && echo "  - $claude_dir/commands/"
            [[ -d "$claude_dir/agents" ]] && echo "  - $claude_dir/agents/"
            [[ -d "$knowzcode_dir" ]] && echo "  - $knowzcode_dir/"
            echo ""
            print_error "Use --force to overwrite existing installation."
            exit 1
        else
            print_warning "Overwriting existing installation (--force specified)"
        fi
    fi
}

# Copy directory with creation
copy_directory() {
    local src="$1"
    local dst="$2"

    mkdir -p "$dst"
    cp -r "$src"/* "$dst/" 2>/dev/null || true
}

# Initialize tracker file
init_tracker() {
    local tracker_file="$1"

    cat > "$tracker_file" << 'EOF'
# KnowzCode - Status Map

**Purpose:** This document tracks the development status of all implementable components (NodeIDs) defined in `knowzcode_architecture.md`.

---
**Progress: 0%**
---

| Status | WorkGroupID | Node ID | Label | Dependencies | Logical Grouping | Spec Link | Classification | Notes / Issues |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| | | | | | | | | |

---
### Status Legend:

*   ⚪️ **`[TODO]`**: Task is defined and ready to be picked up if dependencies are met.
*   📝 **`[NEEDS_SPEC]`**: Node has been identified but requires a detailed specification.
*   ◆ **`[WIP]`**: Work In Progress. The KnowzCode AI Agent is currently working on this node.
*   🟢 **`[VERIFIED]`**: Node has been implemented and verified.
*   ❗ **`[ISSUE]`**: A significant issue or blocker has been identified.

---
*(This table will be populated as you define your architecture and NodeIDs.)*
EOF
}

# Initialize log file
init_log() {
    local log_file="$1"
    local timestamp
    timestamp="$(date '+%Y-%m-%d %H:%M:%S')"

    cat > "$log_file" << EOF
# KnowzCode - Operational Record

**Purpose:** Chronological record of significant events, decisions, and verification outcomes.

---

## Section 1: Operational Log

---
**[NEWEST ENTRIES APPEAR HERE - DO NOT REMOVE THIS MARKER]**
---
**Type:** SystemInitialization
**Timestamp:** $timestamp
**NodeID(s):** Project-Wide
**Logged By:** install.sh
**Details:**
KnowzCode framework installed via shell script installer.
- Commands and agents installed
- Framework files initialized
- Ready for first feature: run \`/kc "Your feature"\`
---

## Section 2: Reference Quality Criteria (ARC-Based Verification)

### Core Quality Criteria
1.  **Maintainability:** Ease of modification, clarity of code and design.
2.  **Reliability:** Robustness of error handling, fault tolerance.
3.  **Testability:** Adequacy of unit test coverage, ease of testing.
4.  **Performance:** Responsiveness, efficiency in resource utilization.
5.  **Security:** Resistance to common vulnerabilities.

### Structural Criteria
6.  **Readability:** Code clarity, adherence to naming conventions.
7.  **Complexity Management:** Avoidance of overly complex logic.
8.  **Modularity:** Adherence to Single Responsibility Principle.
9.  **Code Duplication (DRY):** Minimization of redundant code.
10. **Standards Compliance:** Adherence to language best practices.

*(Refer to these criteria during ARC-Based Verification.)*
EOF
}

# Main installation function
install_knowzcode() {
    local claude_target

    # Determine where to install Claude commands/agents
    if [[ "$GLOBAL_INSTALL" == true ]]; then
        claude_target="$HOME/.claude"
        print_info "Installing commands globally to $claude_target/"
    else
        claude_target="$TARGET_DIR/.claude"
        print_info "Installing commands locally to $claude_target/"
    fi

    # Check for existing installation
    check_existing "$claude_target"

    # Create directories
    print_info "Creating directories..."
    mkdir -p "$claude_target/commands"
    mkdir -p "$claude_target/agents"
    mkdir -p "$TARGET_DIR/knowzcode/specs"
    mkdir -p "$TARGET_DIR/knowzcode/workgroups"
    mkdir -p "$TARGET_DIR/knowzcode/prompts"
    mkdir -p "$TARGET_DIR/knowzcode/planning"

    # Copy commands and agents
    print_info "Installing commands..."
    copy_directory "$SCRIPT_DIR/claude/commands" "$claude_target/commands"

    print_info "Installing agents..."
    copy_directory "$SCRIPT_DIR/claude/agents" "$claude_target/agents"

    # Copy framework files
    print_info "Installing framework files..."

    # Copy core knowzcode files (not directories)
    for file in "$SCRIPT_DIR/knowzcode"/*.md; do
        if [[ -f "$file" ]]; then
            local filename
            filename="$(basename "$file")"
            # Skip tracker and log - we'll initialize fresh ones
            if [[ "$filename" != "knowzcode_tracker.md" ]] && [[ "$filename" != "knowzcode_log.md" ]]; then
                cp "$file" "$TARGET_DIR/knowzcode/"
            fi
        fi
    done

    # Copy prompts
    if [[ -d "$SCRIPT_DIR/knowzcode/prompts" ]]; then
        copy_directory "$SCRIPT_DIR/knowzcode/prompts" "$TARGET_DIR/knowzcode/prompts"
    fi

    # Copy planning readme if exists
    if [[ -f "$SCRIPT_DIR/knowzcode/planning/Readme.md" ]]; then
        cp "$SCRIPT_DIR/knowzcode/planning/Readme.md" "$TARGET_DIR/knowzcode/planning/"
    fi

    # Copy specs readme if exists
    if [[ -f "$SCRIPT_DIR/knowzcode/specs/Readme.md" ]]; then
        cp "$SCRIPT_DIR/knowzcode/specs/Readme.md" "$TARGET_DIR/knowzcode/specs/"
    fi

    # Copy workgroups readme if exists
    if [[ -f "$SCRIPT_DIR/knowzcode/workgroups/README.md" ]]; then
        cp "$SCRIPT_DIR/knowzcode/workgroups/README.md" "$TARGET_DIR/knowzcode/workgroups/"
    fi

    # Initialize fresh tracker and log
    print_info "Initializing tracker..."
    init_tracker "$TARGET_DIR/knowzcode/knowzcode_tracker.md"

    print_info "Initializing log..."
    init_log "$TARGET_DIR/knowzcode/knowzcode_log.md"

    # Print success message
    echo ""
    print_success "KnowzCode installation complete!"
    echo ""
    echo "Installed to:"
    echo "  Commands/Agents: $claude_target/"
    echo "  Framework:       $TARGET_DIR/knowzcode/"
    echo ""
    echo "Next steps:"
    echo "  1. Edit $TARGET_DIR/knowzcode/environment_context.md"
    echo "     Configure your build commands, test commands, etc."
    echo ""
    echo "  2. Edit $TARGET_DIR/knowzcode/knowzcode_project.md"
    echo "     Set your project name, standards, and priorities."
    echo ""
    echo "  3. Start your first feature:"
    echo "     cd $TARGET_DIR"
    echo "     /kc \"Your first feature description\""
    echo ""
}

# Main entry point
main() {
    echo ""
    echo "========================================="
    echo "  KnowzCode Shell Installer"
    echo "========================================="
    echo ""

    parse_args "$@"
    validate_source
    install_knowzcode
}

main "$@"
