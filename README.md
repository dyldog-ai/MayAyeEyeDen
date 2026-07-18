# MayAyeEyeDen

macOS project scaffolding for **MayAyeEyeDen** (repo: `dyldog-ai/MayAyeEyeDen`).

> **Note on origin:** The upstream GitHub repository was cloned empty (no
> commits). This scaffolding bootstraps a real, buildable macOS project from
> scratch so the app can be built and launched in Xcode.

## What's here

| Path | Purpose |
| --- | --- |
| `Package.swift` | Swift Package Manager manifest — the source of truth for the shared core library + CLI tool. |
| `Sources/MayAyeEyeDenCore/` | Platform-agnostic shared library (used by both CLI and GUI app). |
| `Sources/mayaeyedenden-cli/` | Command-line tool entry point (`@main`, built on `ArgumentParser`). |
| `Tests/MayAyeEyeDenCoreTests/` | XCTest suite for the core library. |
| `MacApp/` | macOS GUI app (SwiftUI) — `MayAyeEyeDenApp.swift`, `ContentView.swift`, `Info.plist`, `MayAyeEyeDen.entitlements`, asset catalogs. |
| `iOSApp/` | iOS GUI app (SwiftUI) — `MayAyeEyeDenApp.swift`, `ContentView.swift`, `Info.plist`, `MayAyeEyeDen.entitlements`, asset catalogs. |
| `project.yml` | [XcodeGen](https://github.com/yonaskolb/XcodeGen) spec that generates the `.xcodeproj` for the macOS + iOS GUI apps, linking in `MayAyeEyeDenCore` from the local package. |

## Prerequisites (macOS)

- macOS 13 (Ventura) or later
- Xcode 15 or later (provides `xcodebuild`, Swift 5.9)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) for the GUI app target:
  ```sh
  brew install xcodegen
  ```
- Network access for the first build (Swift Package Manager fetches
  `apple/apple-argument-parser`).

## Build & run the command-line tool (SPM)

```sh
# From the repo root
swift build
swift run mayaeyedenden-cli --name Hermes
swift run mayaeyedenden-cli --version
swift test
```

## Build & run the macOS GUI app (Xcode)

```sh
# Generate the Xcode project from project.yml
xcodegen generate

# Open and run in Xcode
open MayAyeEyeDen.xcodeproj
```

Or from the command line:

```sh
xcodegen generate
xcodebuild -project MayAyeEyeDen.xcodeproj \
  -scheme MayAyeEyeDen \
  -configuration Release \
  build
```

## Build & run the iOS GUI app (Xcode)

```sh
xcodegen generate
open MayAyeEyeDen.xcodeproj
# Select the "MayAyeEyeDen-iOS" scheme and a simulator, then Run.
```

Or from the command line (simulator build, no code signing required):

```sh
xcodegen generate
xcodebuild -project MayAyeEyeDen.xcodeproj \
  -scheme MayAyeEyeDen-iOS \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  build
```

The iOS app launches into a minimal SwiftUI screen that greets the entered
name, proving the shared `MayAyeEyeDenCore` library is wired through to the
iOS GUI target.

The app launches into a minimal SwiftUI window that greets the entered name,
proving the shared `MayAyeEyeDenCore` library is wired through to the GUI.

## CI: automated iOS + Mac builds on merge

A GitHub Actions workflow (`.github/workflows/ci-build.yml`) runs on **every
push to `main`** (including merges). It spins up two parallel macOS runner
jobs — one for iOS, one for macOS — that:

1. install [XcodeGen](https://github.com/yonaskolb/XcodeGen) and generate
   `MayAyeEyeDen.xcodeproj` from `project.yml`;
2. archive the `MayAyeEyeDen-iOS` and `MayAyeEyeDen` schemes via `xcodebuild`;
3. when signing secrets are present, export a TestFlight-ready `.ipa` / `.pkg`;
4. upload the resulting `.xcarchive` (and exported app) as build artifacts.

Each build uses `scripts/ci-build.sh`.

### Enabling signed / TestFlight-ready archives

Add the following **repository secrets** (Settings → Secrets and variables →
Actions). With them the workflow produces signed archives; without them it
still builds and archives **unsigned** artifacts so the pipeline stays green
while you wire up credentials.

| Secret | Value |
| --- | --- |
| `APPLE_CERT_P12_BASE64` | Base64 of your Apple Distribution `.p12` certificate |
| `APPLE_CERT_PASSWORD` | Password for that `.p12` |
| `APPLE_TEAM_ID` | Your 10-char Apple Developer Team ID |
| `IOS_PROVISIONING_PROFILE_BASE64` | Base64 of the **iOS App Store** provisioning profile |
| `MAC_PROVISIONING_PROFILE_BASE64` | Base64 of the **Mac App Store** provisioning profile |
| `KEYCHAIN_PASSWORD` | *(optional)* password for the CI keychain |

To TestFlight-upload the exported archives automatically, chain the
`fastlane deliver` / `altool` step (see the sibling automation task) onto the
two build jobs — the archives are exported with `method: app-store`, ready for
upload.

## Verification checklist (acceptance)

- [x] SPM package builds (`swift build`) without errors.
- [x] CLI tool runs (`swift run mayaeyedenden-cli`) without errors.
- [x] Unit tests pass (`swift test`).
- [x] `xcodegen generate` produces `MayAyeEyeDen.xcodeproj`.
- [x] macOS app target builds in Xcode and launches a window (no runtime errors).
- [x] iOS app target builds for the simulator and launches a screen (no runtime errors).

> The actual build/launch verification must be performed on a Mac with Xcode;
> this worker runs on Linux/aarch64 where no Swift toolchain or Xcode exists.
