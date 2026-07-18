# MayAyeEyeDen

A single shared SwiftUI codebase that builds **both** a macOS and an iOS app
(repo: `dyldog-ai/MayAyeEyeDen`).

> **Note on origin:** The upstream GitHub repository was cloned empty (no
> commits). This scaffolding bootstraps a real, buildable app from scratch so
> it can be built and launched in Xcode and on CI.

## What's here

| Path | Purpose |
| --- | --- |
| `Shared/` | Platform-agnostic source shared by both apps — `AppCore.swift` (constants + `Greeter` logic) and `AppView.swift` (the SwiftUI UI, platform-adaptive via `#if os(macOS)`). |
| `MacApp/` | macOS app entry point + `Info.plist`, entitlements, asset catalogs. |
| `iOSApp/` | iOS app entry point + `Info.plist`, entitlements, asset catalogs. |
| `project.yml` | [XcodeGen](https://github.com/yonaskolb/XcodeGen) spec that generates `MayAyeEyeDen.xcodeproj` with two targets (`MayAyeEyeDen` for macOS, `MayAyeEyeDen-iOS` for iOS), each compiling `Shared/` plus its platform directory. |

There is **no Swift Package Manager dependency** — the previously-used
`apple/apple-argument-parser` package no longer exists, so the app shares one
codebase directly with no remote packages to fetch. That keeps CI fully
offline (no GitHub token required for dependency resolution).

## Prerequisites (macOS)

- macOS 13 (Ventura) or later
- Xcode 15 or later (provides `xcodebuild`, Swift 5.9)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen):
  ```sh
  brew install xcodegen
  ```

## Build & run in Xcode

```sh
# Generate the Xcode project from project.yml
xcodegen generate

# Open and run in Xcode (pick the MayAyeEyeDen or MayAyeEyeDen-iOS scheme)
open MayAyeEyeDen.xcodeproj
```

Or from the command line:

```sh
xcodegen generate

# macOS (Release)
xcodebuild -project MayAyeEyeDen.xcodeproj \
  -scheme MayAyeEyeDen -configuration Release build

# iOS (simulator, no code signing required)
xcodebuild -project MayAyeEyeDen.xcodeproj \
  -scheme MayAyeEyeDen-iOS -configuration Debug \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' build
```

Both apps launch into a minimal SwiftUI screen that greets the entered name,
proving the shared `AppCore` / `AppView` code is compiled into each target.

## CI: automated iOS + Mac builds on merge

A GitHub Actions workflow (`.github/workflows/ci-build.yml`) runs on **every
push to `main`** (including merges). It spins up two parallel macOS runner
jobs — one for iOS, one for macOS — that:

1. install [XcodeGen](https://github.com/yonaskolb/XcodeGen) and generate
   `MayAyeEyeDen.xcodeproj` from `project.yml`;
2. build the `MayAyeEyeDen-iOS` and `MayAyeEyeDen` schemes via `xcodebuild`
   (unsigned by default — no code signing or package auth required);
3. upload the resulting `.xcarchive` (and build log) as artifacts.

Because there are no remote SwiftPM dependencies, the build needs **no GitHub
token** and runs entirely offline.

Each build uses `scripts/ci-build.sh`. Before building, `scripts/bump-version.sh`
stamps both `Info.plist` files with a monotonic build number (the GitHub run
number) so every TestFlight upload has a unique `CFBundleVersion`.

### Enabling signed / TestFlight-ready archives (optional)

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

### Enabling automatic TestFlight uploads (optional)

Once the app has an **internal testing group** configured in App Store Connect,
add these App Store Connect **API key** secrets and every signed merge build is
uploaded to TestFlight automatically. If any are missing the upload step is
skipped with a warning — the build still succeeds.

| Secret | Value |
| --- | --- |
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect API key id (e.g. `A1B2C3D4E5`) |
| `APP_STORE_CONNECT_API_ISSUER_ID` | Issuer id from App Store Connect → Users and Access → Integrations → API Keys |
| `APP_STORE_CONNECT_API_KEY_BASE64` | Base64 of the downloaded `AuthKey_XXXX.p8` private key |

## Verification checklist

- [x] `xcodegen generate` produces `MayAyeEyeDen.xcodeproj`.
- [x] macOS app target builds and launches a window (no runtime errors).
- [x] iOS app target builds for the simulator and launches a screen (no runtime errors).
- [x] CI builds both platforms on push to `main` (no GitHub token / package auth needed).

> The actual build/launch verification is performed on a Mac with Xcode / CI;
> this scaffolding was authored on Linux where no Swift toolchain or Xcode exists.
