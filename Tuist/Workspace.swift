import ProjectDescription

// Single workspace that contains the generated MayAyeEyeDen project.
// `.` resolves to the directory holding this manifest (the repo root), so
// `tuist generate` writes `MayAyeEyeDen.xcworkspace` next to Project.swift,
// replacing the old XcodeGen-generated `MayAyeEyeDen.xcodeproj`.
let workspace = Workspace(
    name: "MayAyeEyeDen",
    projects: ["."]
)
