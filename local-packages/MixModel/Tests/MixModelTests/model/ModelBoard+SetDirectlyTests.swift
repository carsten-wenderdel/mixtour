import XCTest
@testable import MixModel

class ModelBoard_SetDirectlyTests: XCTestCase {

    /// Also tests correct id for both setting and dragging
    func testPiecesAtSquare() {
        // Given
        let board = ModelBoard()
        let square = ModelSquare(column: 3, line: 2)

        // When
        board.setPiecesDirectlyToSquare(square, .white, .white, .black)
        let pieces = board.piecesAtSquare(square)

        // Then
        XCTAssertEqual(pieces, [
            ModelPiece(color: .black, id: 38),
            ModelPiece(color: .white, id: 39),
            ModelPiece(color: .white, id: 40)
        ])
    }
}
