#!/usr/bin/env bash
# ci-build.sh — build + archive a MayAyeEyeDen scheme for CI.
#
# Used by .github/workflows/ci-build.yml on a macOS GitHub runner. It generates
# the Xcode project from project.yml (XcodeGen), archives the requested scheme,
# and (when signing is enabled) exports a TestFlight-ready .ipa (iOS) / .pkg
# (macOS) using the matching export-options plist.
#
# Usage:
#   ci-build.sh --scheme SCHEME --destination DEST --config CONFIG \
#               --export-method METHOD --signing yes|no [--team TEAM_ID]
set -euo pipefail

SCHEME=""
DESTINATION=""
CONFIG="Release"
EXPORT_METHOD="app-store"
SIGNING="no"
TEAM=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --scheme)        SCHEME="$2"; shift 2 ;;
    --destination)   DESTINATION="$2"; shift 2 ;;
    --config)        CONFIG="$2"; shift 2 ;;
    --export-method) EXPORT_METHOD="$2"; shift 2 ;;
    --signing)       SIGNING="$2"; shift 2 ;;
    --team)          TEAM="$2"; shift 2 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
done

if [[ -z "$SCHEME" || -z "$DESTINATION" ]]; then
  echo "ERROR: --scheme and --destination are required." >&2
  exit 2
fi

PLATFORM_LOWER=$(echo "$SCHEME" | tr '[:upper:]' '[:lower:]')
# Derive a stable artifact/platform label: "MayAyeEyeDen-iOS" -> "ios",
# "MayAyeEyeDen" -> "macos".
case "$SCHEME" in
  *-iOS) PLATFORM="ios" ;;
  *)     PLATFORM="macos" ;;
esac

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "==> XcodeGen: generate MayAyeEyeDen.xcodeproj"
xcodegen generate

ARCHIVE_PATH="build/$SCHEME.xcarchive"
EXPORT_PATH="build/export/$PLATFORM"

echo "==> xcodebuild: archive scheme $SCHEME ($CONFIG, $DESTINATION)"

if [[ "$SIGNING" == "yes" ]]; then
  if [[ -z "$TEAM" ]]; then
    echo "ERROR: --signing yes requires --team (APPLE_TEAM_ID)." >&2
    exit 2
  fi
  SIGN_FLAGS=(
    CODE_SIGN_STYLE=Automatic
    DEVELOPMENT_TEAM="$TEAM"
    CODE_SIGNING_ALLOWED=YES
    CODE_SIGNING_REQUIRED=YES
    -allowProvisioningUpdates
  )
else
  echo "::warning::Building UNSIGNED archive (CODE_SIGNING_ALLOWED=NO). Not TestFlight-ready."
  SIGN_FLAGS=(
    CODE_SIGNING_ALLOWED=NO
    CODE_SIGNING_REQUIRED=NO
  )
fi

xcodebuild archive \
  -project MayAyeEyeDen.xcodeproj \
  -scheme "$SCHEME" \
  -configuration "$CONFIG" \
  -destination "$DESTINATION" \
  -archivePath "$ARCHIVE_PATH" \
  "${SIGN_FLAGS[@]}"

echo "==> Archive produced: $ARCHIVE_PATH"

if [[ "$SIGNING" == "yes" ]]; then
  EXPORT_PLIST="scripts/export-options-$PLATFORM.plist"
  if [[ ! -f "$EXPORT_PLIST" ]]; then
    echo "ERROR: export options plist not found: $EXPORT_PLIST" >&2
    exit 2
  fi
  echo "==> xcodebuild: export $PLATFORM ($EXPORT_METHOD)"
  rm -rf "$EXPORT_PATH"
  mkdir -p "$EXPORT_PATH"
  xcodebuild -exportArchive \
    -archivePath "$ARCHIVE_PATH" \
    -exportPath "$EXPORT_PATH" \
    -exportOptionsPlist "$EXPORT_PLIST" \
    -allowProvisioningUpdates
  echo "==> Exported app artifacts:"
  find "$EXPORT_PATH" -maxdepth 2 -type f
fi

echo "Build & archive complete for $SCHEME."
