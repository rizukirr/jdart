#!/bin/bash

# Build script for jdart CLI tool
# Creates executables for Linux, macOS, and Windows

set -e

VERSION="1.0.0"
OUTPUT_DIR="build/release"

echo "Building jdart v${VERSION}..."
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Build for current platform
echo "Building for current platform..."
dart compile exe bin/jdart.dart -o "$OUTPUT_DIR/jdart"
echo "✓ Built: $OUTPUT_DIR/jdart"
echo ""

# Optionally create archives
echo "Creating archive..."
cd "$OUTPUT_DIR"
tar -czf "jdart-v${VERSION}-$(uname -s)-$(uname -m).tar.gz" jdart
echo "✓ Created: jdart-v${VERSION}-$(uname -s)-$(uname -m).tar.gz"
cd - >/dev/null

echo ""
echo "Build complete! Executable available at: $OUTPUT_DIR/jdart"
echo ""
echo "To install globally, run:"
echo "  sudo cp $OUTPUT_DIR/jdart /usr/local/bin/"
echo ""
echo "Or add to your PATH:"
echo "  export PATH=\"\$PATH:$(pwd)/$OUTPUT_DIR\""
