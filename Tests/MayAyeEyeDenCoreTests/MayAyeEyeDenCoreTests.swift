import XCTest
@testable import MayAyeEyeDenCore

final class MayAyeEyeDenCoreTests: XCTestCase {
    func testGreeterIncludesNameAndProduct() {
        let greeter = Greeter()
        let message = greeter.greet(name: "tester")

        XCTAssertTrue(message.contains("tester"), "Greeting should mention the provided name.")
        XCTAssertTrue(message.contains("MayAyeEyeDen"), "Greeting should mention the product name.")
    }

    func testVersionIsNonEmpty() {
        XCTAssertFalse(MayAyeEyeDenCore.version.isEmpty, "Version string must be set.")
    }
}
