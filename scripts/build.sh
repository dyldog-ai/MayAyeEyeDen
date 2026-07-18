#!/usr/bin/env bash
# Build verification helper for MayAyeEyeDen (macOS).
# Run on a Mac with Xcode 15+ and Tuist installed.
set -euo pipefail

if command -v tuist >/dev/null 2>&1; then
  echo "==> Tuist: generate workspace"
  tuist generate
  echo "==> xcodebuild: build macOS app scheme"
  xcodebuild -workspace MayAyeEyeDen.xcworkspace -scheme MayAyeEyeDen -configuration Release build
  echo "==> xcodebuild: build iOS app scheme (simulator)"
  xcodebuild -workspace MayAyeEyeDen.xcworkspace -scheme MayAyeEyeDen-iOS \
    -configuration Debug \
    -sdk iphonesimulator \
    -destination 'generic/platform=iOS Simulator' \
    build
else
  echo "!! tuist not found; skipping GUI app workspace generation/build."
  echo "   Install with: curl -Ls https://install.tuist.io | bash"
  exit 1
fi

echo "All build steps completed."
