#!/bin/bash
# This script automates git pull and installation of project dependencies.
# It's designed to be run periodically, e.g., via cron.

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the project directory
PROJECT_DIR="/Users/dpw/raincity/c-projects/auth-service"
BUILD_LIBS_DIR="/tmp/build-libs" # Temporary directory for building dependencies

echo "Starting dependency update at $(date)"

# Change to the project directory
cd "$PROJECT_DIR"

echo "Pulling latest changes from git..."
git pull

# Create temporary build directory
mkdir -p "$BUILD_LIBS_DIR"

# --- Install spdlog ---
if [ ! -d "/usr/local/include/spdlog" ]; then
    echo "Installing spdlog..."
    git clone https://github.com/gabime/spdlog.git "$BUILD_LIBS_DIR/spdlog_temp"
    cd "$BUILD_LIBS_DIR/spdlog_temp"
    git checkout v1.15.0
    mkdir build && cd build
    cmake ..
    make -j$(sysctl -n hw.ncpu) # Use all available CPU cores
    sudo make install
    cd - # Go back to previous directory
    echo "spdlog installed."
else
    echo "spdlog already installed."
fi

# --- Install nlohmann_json ---
if [ ! -d "/usr/local/include/nlohmann" ]; then
    echo "Installing nlohmann_json..."
    git clone https://github.com/nlohmann/json.git "$BUILD_LIBS_DIR/json_temp"
    cd "$BUILD_LIBS_DIR/json_temp"
    git checkout v3.11.3
    mkdir build && cd build
    cmake ..
    sudo make install
    cd -
    echo "nlohmann_json installed."
else
    echo "nlohmann_json already installed."
fi

# --- Install Catch2 ---
if [ ! -d "/usr/local/include/catch2" ]; then
    echo "Installing Catch2..."
    git clone https://github.com/CatchOrg/Catch2.git "$BUILD_LIBS_DIR/catch2_temp"
    cd "$BUILD_LIBS_DIR/catch2_temp"
    git checkout v3.6.0
    mkdir build && cd build
    cmake ..
    make -j$(sysctl -n hw.ncpu)
    sudo make install
    cd -
    echo "Catch2 installed."
else
    echo "Catch2 already installed."
fi

# --- Verify termio, quickkv, domainkeys (already installed, just check presence) ---
echo "Verifying termio, quickkv, and domainkeys presence..."
if [ ! -f "/usr/local/include/termio/termio.hpp" ]; then
    echo "Warning: termio header not found. Please ensure it's installed."
fi
if [ ! -f "/usr/local/include/quickkv/quickkv.hpp" ]; then
    echo "Warning: quickkv header not found. Please ensure it's installed."
fi
if [ ! -f "/usr/local/include/domainkeys/domainkeys.hpp" ]; then
    echo "Warning: domainkeys header not found. Please ensure it's installed."
fi

# Clean up temporary build directories
echo "Cleaning up temporary build directories..."
rm -rf "$BUILD_LIBS_DIR"

echo "Dependency update finished at $(date)"
