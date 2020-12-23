import XCTest
import Core

class MIXCoreHelperTests : XCTestCase {
    
    func testSignum() {
        XCTAssertEqual(signum(-3), -1)
        XCTAssertEqual(signum(-1), -1)
        XCTAssertEqual(signum(0), 0)
        XCTAssertEqual(signum(1), 1)
        XCTAssertEqual(signum(3), 1)
    }
}

