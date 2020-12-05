import XCTest
@testable import MixModel

final class MixModelTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MixModel().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
