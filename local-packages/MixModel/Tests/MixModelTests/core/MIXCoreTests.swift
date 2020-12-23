import XCTest
import Core

class MIXCoreTests: XCTestCase {

    
    let move1 = MIXCoreMoveMakeDrag(MIXCoreSquare(column: 1, line: 1),
                                    MIXCoreSquare(column: 2, line: 2),
                                    2)
    let move2 = MIXCoreMoveMakeDrag(MIXCoreSquare(column: 2, line: 2),
                                    MIXCoreSquare(column: 1, line: 1),
                                    2)


    func testReverseDragIsFound() {
        XCTAssert(isMoveRevertOfMove(move1, move2))
    }
    
    func testDifferentNumbersOfPiecesIsNotRevert() {
        var move2DifferentNumbers = move2
        move2DifferentNumbers.numberOfPieces = 1
        XCTAssertFalse(isMoveRevertOfMove(move1, move2DifferentNumbers))
    }

    func testDifferentFromIsNotRevert() {
        var move2DifferentFrom = move2
        move2DifferentFrom.from = MIXCoreSquare(column: 3, line: 3)
        XCTAssertFalse(isMoveRevertOfMove(move1, move2DifferentFrom))
    }

    func testDifferentToIsNotRevert() {
        var move2DifferentTo = move2
        move2DifferentTo.to = MIXCoreSquare(column: 3, line: 3)
        XCTAssertFalse(isMoveRevertOfMove(move1, move2DifferentTo))
    }
}

