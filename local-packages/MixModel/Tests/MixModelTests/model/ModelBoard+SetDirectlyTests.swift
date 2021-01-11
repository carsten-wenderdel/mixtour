import XCTest
@testable import MixModel

class Board_SetDirectlyTests: XCTestCase {

    /// Also tests correct id for both setting and dragging
    func testPiecesAtSquare() {
        // Given
        let board = Board()
        let square = Square(column: 3, line: 2)

        // When
        board.setPiecesDirectlyToSquare(square, .white, .white, .black)
        let pieces = board.piecesAtSquare(square)

        // Then
        XCTAssertEqual(pieces, [
            Piece(color: .black, id: 119),
            Piece(color: .white, id: 18),
            Piece(color: .white, id: 19)
        ])

        // Ids also set correctly
        XCTAssert(board.unusedPieces[.black]!.filter{ $0.id == 119 }.isEmpty)
        XCTAssert(board.unusedPieces[.white]!.filter{ $0.id == 18 }.isEmpty)
        XCTAssert(board.unusedPieces[.white]!.filter{ $0.id == 19 }.isEmpty)
        XCTAssertFalse(board.unusedPieces[.black]!.filter{ $0.id == 118 }.isEmpty)
        XCTAssertFalse(board.unusedPieces[.white]!.filter{ $0.id == 17 }.isEmpty)
    }
}
