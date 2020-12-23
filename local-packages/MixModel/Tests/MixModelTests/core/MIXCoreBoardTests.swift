import XCTest
import Core

class MIXCoreBoardTests : XCTestCase {
    
    func testBoard() {
        // Not sure about the difference between strideof and sizeof. Currently Swift documention is not clear enough about it. So better use both in unit test - 64 bytes for C struct!

        XCTAssertEqual(64, MemoryLayout<MIXCoreBoard>.size)
        XCTAssertEqual(64, MemoryLayout<MIXCoreBoard>.stride)
        XCTAssertEqual(4, MemoryLayout<MIXCoreBoard>.alignment)
    }
    
    func testPotentialWinner() {
        // given
        var coreBoard = MIXCoreBoard()
        resetCoreBoard(&coreBoard)
        
        let square1 = MIXCoreSquare(column:1, line:1)
        setPiecesDirectlyWithList(&coreBoard, square1, 1, getVaList([MIXCorePlayerBlack.rawValue]))
        
        let square2 = MIXCoreSquare(column:2, line:2)
        let white = MIXCorePlayerWhite.rawValue;
        setPiecesDirectlyWithList(&coreBoard, square2, 4, getVaList([white, white, white, white]));
        
        // when
        let move = MIXCoreMoveMakeDrag(square2, square1, 4)
        let winner = potentialWinner(&coreBoard, move)
        
        // then
        XCTAssertEqual(winner, MIXCorePlayerWhite)
    }
}

