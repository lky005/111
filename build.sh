#!/bin/bash

# PojavLauncher HarmonyOS Next Build Script
echo "Building PojavLauncher for HarmonyOS Next..."

# Check for HarmonyOS Next SDK
if [ ! -d "$HARMONY_SDK_HOME" ]; then
    echo "Error: HARMONY_SDK_HOME not set or HarmonyOS Next SDK not found"
    echo "Please install HarmonyOS Next SDK and set HARMONY_SDK_HOME environment variable"
    exit 1
fi

# Check for DevEco Studio
if ! command -v hvigor &> /dev/null; then
    echo "Error: hvigor build tool not found"
    echo "Please install DevEco Studio or add hvigor to your PATH"
    exit 1
fi

# Clean previous build
echo "Cleaning previous build..."
hvigor clean

# Install dependencies
echo "Installing dependencies..."
if [ -f "oh-package.json5" ]; then
    npm install
else
    echo "Warning: oh-package.json5 not found, skipping npm install"
fi

# Build the project
echo "Building project..."
hvigor assembleHap

# Check build result
if [ $? -eq 0 ]; then
    echo "Build successful!"
    echo "HAP file location: build/outputs/hap/entry/entry-default-signed.hap"
    
    # Show file size
    if [ -f "build/outputs/hap/entry/entry-default-signed.hap" ]; then
        echo "HAP file size: $(du -h build/outputs/hap/entry/entry-default-signed.hap | cut -f1)"
    fi
else
    echo "Build failed!"
    exit 1
fi

echo "Build completed successfully!"