#!/bin/sh
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_CLEANUP=1

brew install xcodegen

# 2. Generate the project using your manifest
# This creates the .xcodeproj file that Xcode Cloud needs to see
cd ..
xcodegen generate

echo "✅ Xcode project generated successfully."

if [ "$CI_XCODEBUILD_ACTION" = "archive" ]; then
    xcrun agvtool new-version -all $(date +%Y%m%d%H%M%S)
    echo "✅ Build number updated."
fi
