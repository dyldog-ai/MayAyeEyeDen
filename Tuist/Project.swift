import ProjectDescription

// MARK: - Shared settings

let bundleIdPrefix = "com.dyldog"
let deploymentTargets = DeploymentTargets.iOS("16.0").macOS("13.0")

// Platform-agnostic build settings shared by both GUI app targets.
// These reproduce the `base` block from the old `project.yml`.
// The macOS + iOS apps share a single codebase (the `Shared/` folder), so there
// is no Swift package dependency to resolve — the previously-failing
// apple/apple-argument-parser dependency is gone entirely.
let appBaseSettings: SettingsDictionary = [
    "PRODUCT_NAME": "MayAyeEyeDen",
    "SWIFT_VERSION": "5.9",
    "CODE_SIGN_STYLE": "Automatic",
    "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
    "ASSETCATALOG_COMPILER_ACCENT_COLOR_NAME": "AccentColor",
    "GENERATE_INFOPLIST_FILE": "NO",
]

// MARK: - Targets

let macOSApp = Target.target(
    name: "MayAyeEyeDen",
    destinations: [.mac],
    product: .app,
    bundleId: "\(bundleIdPrefix).MayAyeEyeDen",
    deploymentTargets: deploymentTargets,
    infoPlist: .file(path: "MacApp/Info.plist"),
    sources: [
        "Shared",
        "MacApp",
    ],
    resources: [], // assets live inside the source folders and are picked up automatically
    dependencies: [],
    settings: .settings(
        base: appBaseSettings.merging([
            "PRODUCT_BUNDLE_IDENTIFIER": "\(bundleIdPrefix).MayAyeEyeDen",
            "INFOPLIST_FILE": "MacApp/Info.plist",
            "CODE_SIGN_ENTITLEMENTS": "MacApp/MayAyeEyeDen.entitlements",
            "MACOSX_DEPLOYMENT_TARGET": "13.0",
            "ENABLE_HARDENED_RUNTIME": "YES",
        ])
    )
)

let iOSApp = Target.target(
    name: "MayAyeEyeDen-iOS",
    destinations: [.iPhone, .iPad],
    product: .app,
    bundleId: "\(bundleIdPrefix).MayAyeEyeDen",
    deploymentTargets: deploymentTargets,
    infoPlist: .file(path: "iOSApp/Info.plist"),
    sources: [
        "Shared",
        "iOSApp",
    ],
    resources: [], // assets live inside the source folders and are picked up automatically
    dependencies: [],
    settings: .settings(
        base: appBaseSettings.merging([
            "PRODUCT_BUNDLE_IDENTIFIER": "\(bundleIdPrefix).MayAyeEyeDen",
            "INFOPLIST_FILE": "iOSApp/Info.plist",
            "CODE_SIGN_ENTITLEMENTS": "iOSApp/MayAyeEyeDen.entitlements",
            "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
            "TARGETED_DEVICE_FAMILY": "1,2",
            // CI builds unsigned; the entitlements still need to be wired in.
            "CODE_SIGNING_REQUIRED": "NO",
            "CODE_SIGNING_ALLOWED": "NO",
            "DEVELOPMENT_ASSET_PATHS": "\"iOSApp/Preview Content\"",
        ])
    )
)

// MARK: - Project

// `tuist generate` reproduces the same targets/schemes the old `project.yml`
// produced. Automatic per-target schemes are kept enabled (the default), so
// `MayAyeEyeDen` and `MayAyeEyeDen-iOS` schemes exist for `xcodebuild`/CI.
let project = Project(
    name: "MayAyeEyeDen",
    options: .options(
        // Tuist creates intermediate groups by default, matching XcodeGen's
        // `createIntermediateGroups: true`.
        developmentRegion: "en"
    ),
    targets: [macOSApp, iOSApp]
)
