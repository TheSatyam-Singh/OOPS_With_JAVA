#!/bin/bash

# Download MySQL JDBC Driver for Jibble Employee Clock System
# This script downloads mysql-connector-java and places it in WEB-INF/lib

JDBC_DIR="/Users/satyamsingh/Downloads/Jibble/WebContent/WEB-INF/lib"
JDBC_URL="https://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-8.0.33.jar"

echo "📥 Downloading MySQL JDBC Driver..."
mkdir -p "$JDBC_DIR"

cd "$JDBC_DIR"

# Try curl first
if command -v curl &> /dev/null; then
    echo "Using curl to download..."
    curl -L -o mysql-connector-java-8.0.33.jar "$JDBC_URL"
# Fall back to wget
elif command -v wget &> /dev/null; then
    echo "Using wget to download..."
    wget -O mysql-connector-java-8.0.33.jar "$JDBC_URL"
else
    echo "❌ Error: curl or wget not found. Please download manually:"
    echo "$JDBC_URL"
    echo "And place it in: $JDBC_DIR"
    exit 1
fi

# Verify download
if [ -f mysql-connector-java-8.0.33.jar ]; then
    echo "✅ MySQL JDBC Driver downloaded successfully!"
    ls -lh mysql-connector-java-8.0.33.jar
else
    echo "❌ Download failed. Please check your internet connection."
    exit 1
fi
