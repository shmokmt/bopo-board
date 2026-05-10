#!/bin/bash

set -e

APP_NAME="BopoBoard"
VERSION="${VERSION:-1.0}"
DMG_NAME="${APP_NAME}-${VERSION}.dmg"
VOLUME_NAME="${APP_NAME} ${VERSION}"

echo "📦 Creating DMG package for ${APP_NAME} ${VERSION}..."

# Check if app exists
if [ ! -d "${APP_NAME}.app" ]; then
    echo "❌ Error: ${APP_NAME}.app not found. Please build the app first with ./build.sh"
    exit 1
fi

# Create temporary directory
TMP_DIR=$(mktemp -d)
echo "📁 Using temporary directory: ${TMP_DIR}"

# Copy app to temporary directory
echo "📋 Copying ${APP_NAME}.app..."
cp -R "${APP_NAME}.app" "${TMP_DIR}/"

# Create symbolic link to Applications folder
echo "🔗 Creating Applications symlink..."
ln -s /Applications "${TMP_DIR}/Applications"

# Remove old DMG if exists
if [ -f "${DMG_NAME}" ]; then
    echo "🗑️  Removing old ${DMG_NAME}..."
    rm "${DMG_NAME}"
fi

# Create DMG
echo "💿 Creating DMG..."
hdiutil create \
    -volname "${VOLUME_NAME}" \
    -srcfolder "${TMP_DIR}" \
    -ov \
    -format UDZO \
    "${DMG_NAME}"

# Clean up
echo "🧹 Cleaning up..."
rm -rf "${TMP_DIR}"

DMG_SIZE=$(du -h "${DMG_NAME}" | cut -f1)

echo ""
echo "✅ DMG package created successfully!"
echo "📦 File: ${DMG_NAME}"
echo "💾 Size: ${DMG_SIZE}"
