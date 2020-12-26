import XCTest
@testable import Core
@testable import MixModel

class ModelPlayerTests : XCTestCase {

    func testEnumValuesMatchCoreCEnum() {
        XCTAssertEqual(ModelPlayer.white.rawValue, Int(MIXCorePlayerWhite.rawValue))
        XCTAssertEqual(ModelPlayer.black.rawValue, Int(MIXCorePlayerBlack.rawValue))
        XCTAssertEqual(-1, Int(MIXCorePlayerUndefined.rawValue))
    }
    
    func testInitWorksForAllCoreValues() {
        XCTAssertEqual(ModelPlayer(corePlayer: MIXCorePlayerWhite), ModelPlayer.white)
        XCTAssertEqual(ModelPlayer(corePlayer: MIXCorePlayerBlack), ModelPlayer.black)
        XCTAssertEqual(ModelPlayer(corePlayer: MIXCorePlayerUndefined), nil)
    }
    
    func testCorePlayer() {
        XCTAssertEqual(ModelPlayer.white.corePlayer().rawValue, MIXCorePlayerWhite.rawValue)
        XCTAssertEqual(ModelPlayer.black.corePlayer().rawValue, MIXCorePlayerBlack.rawValue)
    }
}

