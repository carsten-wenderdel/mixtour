import XCTest
import Core
@testable import MixModel

class MoveTests: XCTestCase {

    func testDragMoveModelToCore() {
        let fromSquare = Square(column: 3, line: 2)
        let toSquare = Square(column: 4, line: 1)
        let move = Move.drag(from: fromSquare, to: toSquare, numberOfPieces: 1)

        let coreMove = move.coreMove()
        XCTAssert(isMoveDrag(coreMove))
        
        XCTAssertEqual(coreMove.from.column, 3)
        XCTAssertEqual(coreMove.from.line, 2)
        XCTAssertEqual(coreMove.to.column, 4)
        XCTAssertEqual(coreMove.to.line, 1)
    }
    
    func testSetMoveModelToCore() {
        let toSquare = Square(column: 1, line: 4)
        let move = Move.set(to: toSquare)

        let coreMove = move.coreMove()
        XCTAssertFalse(isMoveDrag(coreMove))

        XCTAssertEqual(coreMove.to.column, 1)
        XCTAssertEqual(coreMove.to.line, 4)
    }
    
    func testDragMoveCoreToModel() {
        let coreSquareFrom = MIXCoreSquare(column: 3, line: 2)
        let coreSquareTo = MIXCoreSquare(column:4, line: 1)
        let coreMove = MIXCoreMoveMakeDrag(coreSquareFrom, coreSquareTo, 1)
        
        XCTAssert(isMoveDrag(coreMove))
    
        let move = Move(coreMove)

        guard case let .drag( from, to, numberOfPieces) = move else {
            XCTFail()
            return
        }
        XCTAssertEqual(from.column, 3)
        XCTAssertEqual(from.line, 2)
        XCTAssertEqual(to.column, 4)
        XCTAssertEqual(to.line, 1)
        XCTAssertEqual(numberOfPieces, 1)
    }
    
    func testSetMoveCoreToModel() {
        let coreSquareTo = MIXCoreSquare(column: 2, line: 4)
        let coreMove = MIXCoreMoveMakeSet(coreSquareTo)
        
        XCTAssertFalse(isMoveDrag(coreMove))
        
        let move = Move(coreMove)
        guard case let .set(to) = move else {
            XCTFail()
            return
        }
        XCTAssertEqual(to.column, 2)
        XCTAssertEqual(to.line, 4)
    }
    
    func testEqualityForSetting() {
        let setMove1a = Move.set(to: Square(column: 1, line: 1))
        let setMove1b = Move.set(to: Square(column: 1, line: 1))
        let setMove2 = Move.set(to: Square(column: 1, line: 2))
        
        XCTAssertEqual(setMove1a, setMove1b)
        XCTAssertNotEqual(setMove1a, setMove2)
    }
    
    func testEqualityForSettingWithDifferentNonImportantInstanceVariables() {
        let setMove1a = Move.set(to: Square(column: 1, line: 1))

        let setMove1b = Move.drag(
            from: Square(column: 3, line: 4),
            to: Square(column: 1, line: 1),
            numberOfPieces: 55
        )
        
        XCTAssertEqual(setMove1a, setMove1b)
    }
    
    func testEqualityForDragging() {
        let square1 = Square(column: 1, line: 1)
        let square2 = Square(column: 2, line: 2)
        
        let dragMove1a = Move.drag(from: square1, to: square2, numberOfPieces: 1)
        let dragMove1b = Move.drag(from: square1, to: square2, numberOfPieces: 1)
        let dragMove2 = Move.drag(from: square1, to: square2, numberOfPieces: 2)
        let dragMove3 = Move.drag(from: square2, to: square1, numberOfPieces: 1)
        
        XCTAssertEqual(dragMove1a, dragMove1b)
        XCTAssertNotEqual(dragMove1a, dragMove2)
        XCTAssertNotEqual(dragMove1a, dragMove3)
    }
}
