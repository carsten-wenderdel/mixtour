import XCTest
@testable import MixModel

class CachePlayerTests: XCTestCase {

    private class ComputerPlayerStub: ComputerPlayer {

        private var moves: [Move] = [
            .set(to: .init(column: 0, line: 2)),
            .set(to: .init(column: 0, line: 1)),
            .set(to: .init(column: 0, line: 0))
        ]

        func bestMove(_ board: Board) -> Move? {
            return moves.popLast()
        }
    }

    func testBestMoveIsTheSameWhenAskedAgain() {

        // Given
        let playerUnderTest = CachePlayer(ComputerPlayerStub())

        let boardA = Board()
        let boardB: Board = {
            let board = Board()
            board.setPiecesDirectlyToSquare(.init(column: 0, line: 0), .black)
            return board
        }()
        let boardC: Board = {
            let board = Board()
            board.setPiecesDirectlyToSquare(.init(column: 0, line: 0), .white, .white)
            return board
        }()

        // When
        let moveA1 = playerUnderTest.bestMove(boardA)
        let moveB1 = playerUnderTest.bestMove(boardB)
        let moveC1 = playerUnderTest.bestMove(boardC)

        let moveA2 = playerUnderTest.bestMove(boardA)
        let moveB2 = playerUnderTest.bestMove(boardB)
        let moveC2 = playerUnderTest.bestMove(boardC)

        // Then
        XCTAssertEqual(moveA1, moveA2)
        XCTAssertEqual(moveB1, moveB2)
        XCTAssertEqual(moveC1, moveC2)

        XCTAssertNotEqual(moveA1, moveB1)
        XCTAssertNotEqual(moveB1, moveC1)
        XCTAssertNotEqual(moveC1, moveA1)
    }
}
