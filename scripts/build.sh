#!/usr/bin/env bash
# Local build verification helper for MayAyeEyeDen (macOS).
# Generates the Xcode project from project.yml (XcodeGen) and builds both
# the macOS and iOS app targets. The apps share a single codebase (Shared/)
# and no longer depend on a Swift package, so there is nothing to resolve
# with Swift Package Manager.
set -euo pipefail

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "!! xcodegen not found. Install with: brew install xcodegen" >&2
  exit 1
fi

echo "==> XcodeGen: generate project"
xcodegen generate

echo "==> xcodebuild: build macOS app scheme (Release)"
xcodebuild -project MayAyeEyeDen.xcodeproj \
  -scheme MayAyeEyeDen \
  -configuration Release \
  build

echo "==> xcodebuild: build iOS app scheme (Debug, simulator)"
xcodebuild -project MayAyeEyeDen.xcodeproj \
  -scheme MayAyeEyeDen-iOS \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  build

echo "All build steps completed."
