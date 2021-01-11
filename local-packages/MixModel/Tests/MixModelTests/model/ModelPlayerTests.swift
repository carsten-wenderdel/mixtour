import XCTest
@testable import Core
@testable import MixModel

class ModelPlayerTests : XCTestCase {

    func testEnumValuesMatchCoreCEnum() {
        XCTAssertEqual(PlayerColor.white.rawValue, Int(MIXCorePlayerWhite.rawValue))
        XCTAssertEqual(PlayerColor.black.rawValue, Int(MIXCorePlayerBlack.rawValue))
        XCTAssertEqual(-1, Int(MIXCorePlayerUndefined.rawValue))
    }
    
    func testInitWorksForAllCoreValues() {
        XCTAssertEqual(PlayerColor(corePlayer: MIXCorePlayerWhite), PlayerColor.white)
        XCTAssertEqual(PlayerColor(corePlayer: MIXCorePlayerBlack), PlayerColor.black)
        XCTAssertEqual(PlayerColor(corePlayer: MIXCorePlayerUndefined), nil)
    }
    
    func testCorePlayer() {
        XCTAssertEqual(PlayerColor.white.corePlayer().rawValue, MIXCorePlayerWhite.rawValue)
        XCTAssertEqual(PlayerColor.black.corePlayer().rawValue, MIXCorePlayerBlack.rawValue)
    }
}

