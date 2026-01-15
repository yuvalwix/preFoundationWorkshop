#!/bin/bash

# macOS Development Tools Validation Script
# Checks for Node.js, Python, and Git
# Lists installed tools with their versions
#
# IMPORTANT: This script is READ-ONLY and does NOT install anything.
# It only checks and reports what is currently installed on the system.

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print functions
print_header() {
    echo -e "${CYAN}════════════════════════════════════════${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}════════════════════════════════════════${NC}"
}

print_installed() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_not_installed() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: This script is designed for macOS only.${NC}"
    exit 1
fi

# Get macOS version
os_version=$(sw_vers -productVersion)
os_name=$(sw_vers -productName)

# Header
clear
print_header "macOS Development Tools Validation (Read-Only)"
echo ""
print_info "System: $os_name $os_version"
print_info "Architecture: $(uname -m)"
echo ""
echo -e "${YELLOW}Note: This script only checks what is installed.${NC}"
echo -e "${YELLOW}It does NOT install or modify anything.${NC}"
echo ""
echo "Checking installed development tools..."
echo ""

# Track results
tools_installed=0
tools_missing=0
results=()

# Check Node.js
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Node.js${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if command -v node &> /dev/null; then
    node_version=$(node --version)
    node_path=$(which node)
    print_installed "Node.js"
    echo "  Version: $node_version"
    echo "  Path: $node_path"
    results+=("Node.js: ✅ $node_version")
    ((tools_installed++))
    
    # Also check npm
    if command -v npm &> /dev/null; then
        npm_version=$(npm --version)
        npm_path=$(which npm)
        echo ""
        print_installed "npm (Node Package Manager)"
        echo "  Version: $npm_version"
        echo "  Path: $npm_path"
        results+=("npm: ✅ v$npm_version")
    else
        echo ""
        print_not_installed "npm"
        echo "  Status: Not found (should come with Node.js)"
        results+=("npm: ❌ Not found")
    fi
else
    print_not_installed "Node.js"
    echo "  Status: Not installed"
    results+=("Node.js: ❌ Not installed")
    ((tools_missing++))
fi
echo ""

# Check Python
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Python${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if command -v python3 &> /dev/null; then
    python_version=$(python3 --version 2>&1)
    python_path=$(which python3)
    print_installed "Python 3"
    echo "  Version: $python_version"
    echo "  Path: $python_path"
    results+=("Python 3: ✅ $python_version")
    ((tools_installed++))
    
    # Check for pip
    if command -v pip3 &> /dev/null; then
        pip_version=$(pip3 --version 2>&1 | head -n 1)
        echo ""
        print_installed "pip3 (Python Package Manager)"
        echo "  Version: $pip_version"
        results+=("pip3: ✅ Installed")
    fi
else
    print_not_installed "Python 3"
    echo "  Status: Not installed"
    results+=("Python 3: ❌ Not installed")
    ((tools_missing++))
fi
echo ""

# Check Git
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}Git${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

if command -v git &> /dev/null; then
    git_version=$(git --version)
    git_path=$(which git)
    print_installed "Git"
    echo "  Version: $git_version"
    echo "  Path: $git_path"
    results+=("Git: ✅ $git_version")
    ((tools_installed++))
else
    print_not_installed "Git"
    echo "  Status: Not installed"
    results+=("Git: ❌ Not installed")
    ((tools_missing++))
fi
echo ""

# Summary
echo ""
print_header "Summary"
echo ""

# Count total tools checked (3 main tools)
total_tools=3

echo "Tools Status:"
echo "  Installed: $tools_installed/$total_tools"
echo "  Missing: $tools_missing/$total_tools"
echo ""

# List all results
echo "Detailed Results:"
for result in "${results[@]}"; do
    if [[ $result == *"✅"* ]]; then
        echo -e "  ${GREEN}$result${NC}"
    else
        echo -e "  ${RED}$result${NC}"
    fi
done
echo ""

# Final status
if [ $tools_missing -eq 0 ]; then
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    echo -e "${GREEN}✅ All required tools are installed!${NC}"
    echo -e "${GREEN}════════════════════════════════════════${NC}"
    exit 0
else
    echo -e "${YELLOW}════════════════════════════════════════${NC}"
    echo -e "${YELLOW}⚠️  Some tools are missing${NC}"
    echo -e "${YELLOW}════════════════════════════════════════${NC}"
    echo ""
    echo "Note: This script does not install anything."
    echo ""
    echo "To install missing tools manually, you can:"
    echo "  1. Run the setup script (if available)"
    echo "  2. Install manually using Homebrew:"
    echo "     brew install node python@3.12 git"
    exit 1
fi

