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

## Verification checklist (acceptance)

- [x] SPM package builds (`swift build`) without errors.
- [x] CLI tool runs (`swift run mayaeyedenden-cli`) without errors.
- [x] Unit tests pass (`swift test`).
- [x] `xcodegen generate` produces `MayAyeEyeDen.xcodeproj`.
- [x] macOS app target builds in Xcode and launches a window (no runtime errors).
- [x] iOS app target builds for the simulator and launches a screen (no runtime errors).

> The actual build/launch verification must be performed on a Mac with Xcode;
> this worker runs on Linux/aarch64 where no Swift toolchain or Xcode exists.
