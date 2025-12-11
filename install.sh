#!/bin/bash
# Installation script for jdart
# Usage: curl -fsSL https://raw.githubusercontent.com/yourusername/jdart/main/install.sh | bash

set -e

# Configuration
REPO="rizukirr/jdart"
VERSION="latest"
INSTALL_DIR="$HOME/.local/bin"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Installing jdart...${NC}"
echo ""

# Detect OS and architecture
detect_platform() {
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)

    case "$OS" in
        linux*)
            OS="linux"
            ;;
        darwin*)
            OS="macos"
            ;;
        mingw*|msys*|cygwin*)
            OS="windows"
            ;;
        *)
            echo -e "${RED}Unsupported operating system: $OS${NC}"
            exit 1
            ;;
    esac

    case "$ARCH" in
        x86_64|amd64)
            ARCH="x86_64"
            ;;
        aarch64|arm64)
            ARCH="arm64"
            ;;
        *)
            echo -e "${RED}Unsupported architecture: $ARCH${NC}"
            exit 1
            ;;
    esac

    echo -e "Detected: ${YELLOW}$OS${NC} on ${YELLOW}$ARCH${NC}"
}

# Get latest release version
get_latest_version() {
    if [ "$VERSION" = "latest" ]; then
        VERSION=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v?([^"]+)".*/\1/')
        if [ -z "$VERSION" ]; then
            echo -e "${RED}Failed to get latest version${NC}"
            exit 1
        fi
        echo -e "Latest version: ${YELLOW}v$VERSION${NC}"
    fi
}

# Download and install
install_binary() {
    # Create install directory if it doesn't exist
    mkdir -p "$INSTALL_DIR"

    # Construct download URL
    if [ "$OS" = "windows" ]; then
        FILE="jdart-v${VERSION}-Windows-${ARCH}.zip"
        BINARY="jdart.exe"
    else
        if [ "$OS" = "macos" ]; then
            FILE="jdart-v${VERSION}-Darwin-${ARCH}.tar.gz"
        else
            FILE="jdart-v${VERSION}-Linux-${ARCH}.tar.gz"
        fi
        BINARY="jdart"
    fi

    DOWNLOAD_URL="https://github.com/$REPO/releases/download/v$VERSION/$FILE"

    echo -e "Downloading from: ${YELLOW}$DOWNLOAD_URL${NC}"

    # Download to temporary directory
    TMP_DIR=$(mktemp -d)
    cd "$TMP_DIR"

    if ! curl -fsSL "$DOWNLOAD_URL" -o "$FILE"; then
        echo -e "${RED}Failed to download jdart${NC}"
        echo -e "${YELLOW}Please check if the release exists at: https://github.com/$REPO/releases${NC}"
        rm -rf "$TMP_DIR"
        exit 1
    fi

    # Extract
    echo "Extracting..."
    if [ "$OS" = "windows" ]; then
        unzip -q "$FILE"
    else
        tar -xzf "$FILE"
    fi

    # Install binary
    echo "Installing to $INSTALL_DIR..."
    chmod +x "$BINARY"
    mv "$BINARY" "$INSTALL_DIR/"

    # Cleanup
    cd - > /dev/null
    rm -rf "$TMP_DIR"

    echo -e "${GREEN}✓ jdart installed successfully!${NC}"
}

# Check if install directory is in PATH
check_path() {
    echo ""
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        echo -e "${YELLOW}Warning: $INSTALL_DIR is not in your PATH${NC}"
        echo ""
        echo "Add the following to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
        echo ""
        echo -e "${GREEN}export PATH=\"\$PATH:$INSTALL_DIR\"${NC}"
        echo ""
        echo "Then restart your shell or run:"
        echo -e "${GREEN}source ~/.bashrc${NC}  # or ~/.zshrc"
    else
        echo -e "${GREEN}✓ $INSTALL_DIR is in your PATH${NC}"
    fi
}

# Verify installation
verify_installation() {
    echo ""
    if command -v jdart &> /dev/null; then
        echo -e "${GREEN}✓ jdart is ready to use!${NC}"
        echo ""
        echo "Try it out:"
        echo '  jdart '"'"'{"name": "John", "age": 30}'"'"
    else
        echo -e "${YELLOW}Installation complete, but jdart command not found in PATH${NC}"
        echo "You may need to restart your shell or update your PATH."
    fi
}

# Main installation flow
main() {
    detect_platform
    get_latest_version
    install_binary
    check_path
    verify_installation
}

main
