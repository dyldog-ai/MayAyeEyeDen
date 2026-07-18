#!/usr/bin/env bash
# Build verification helper for MayAyeEyeDen (macOS).
# Run on a Mac with Xcode 15+ and XcodeGen installed.
set -euo pipefail

echo "==> Swift Package Manager: build"
swift build

echo "==> Swift Package Manager: run CLI"
swift run mayaeyedenden-cli --name Hermes

echo "==> Swift Package Manager: test"
swift test

if command -v xcodegen >/dev/null 2>&1; then
  echo "==> XcodeGen: generate project"
  xcodegen generate
  echo "==> xcodebuild: build macOS app scheme"
  xcodebuild -project MayAyeEyeDen.xcodeproj -scheme MayAyeEyeDen -configuration Release build
  echo "==> xcodebuild: build iOS app scheme (simulator)"
  xcodebuild -project MayAyeEyeDen.xcodeproj -scheme MayAyeEyeDen-iOS \
    -configuration Debug \
    -sdk iphonesimulator \
    -destination 'generic/platform=iOS Simulator' \
    build
else
  echo "!! xcodegen not found; skipping GUI app project generation/build."
  echo "   Install with: brew install xcodegen"
fi

echo "All build steps completed."
