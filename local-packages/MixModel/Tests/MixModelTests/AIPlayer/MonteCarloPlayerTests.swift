import XCTest
@testable import MixModel

class MonteCarloPlayerTests: XCTestCase {
    
    func testAIPlayerDoesNotMakeOpponentWin() {
        // given
        let board = Board()
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 0), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 1), .black)
        board.setTurnDirectly(.black)
        let computerPlayer = MonteCarloPlayer.beginner
        
        // when
        let blackMove = computerPlayer.bestMove(board)
        
        // assert
        guard case let .drag(_, _, numberOfPieces) = blackMove else {
            XCTFail()
            return
        }
        XCTAssert(numberOfPieces != 4)
    }
    
    func testAIPlayerDoesNotMakeOpponentWin2() {
        // given
        let board = Board()
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 0), .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 2), .white, .black)
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 0), .white)
        board.setPiecesDirectlyToSquare(Square(column: 3, line: 2), .black, .black, .white)
        board.setPiecesDirectlyToSquare(Square(column: 3, line: 3), .black, .white)
        board.setTurnDirectly(.black)
        let computerPlayer = MonteCarloPlayer.beginner

        // when
        let blackMove = computerPlayer.bestMove(board)
        board.makeMoveIfLegal(blackMove!)
        
        // assert
        XCTAssert(board.isGameOver())
        XCTAssertEqual(board.winner(), PlayerColor.black)
    }

    func testAIPlayerDoesNotMakeOpponentWinDirectlyButOneMoveLater() {
        // Given
        let board = Board()
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 1), .white)
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 0), .black)
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 2), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 3), .white, .black, .black, .black)
        board.setPiecesDirectlyToSquare(Square(column: 3, line: 2), .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 4, line: 1), .white, .black, .black, .white)
        board.setTurnDirectly(.black)
        let computerPlayer = MonteCarloPlayer.beginner

        // when
        let blackMove = computerPlayer.bestMove(board)
        board.makeMoveIfLegal(blackMove!)

        // Then
        XCTAssertFalse(board.isGameOver())
        // Next move white will win anyway, but at least the computer player is not making the last move.
    }

    func testAIPlayerDoesNotLetOpponentWinInNextMove() {
        // given
        let board = Board()
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 2), .black)
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 3), .black, .black, .black)
        board.setPiecesDirectlyToSquare(Square(column: 2, line: 0), .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 3, line: 0), .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 3, line: 2), .white, .black, .black, .white)
        board.setTurnDirectly(.black)
        let computerPlayer = MonteCarloPlayer.beginner

        // when
        let blackMove = computerPlayer.bestMove(board)
        
        // then
        
        // Opponent could win by dragging with distance 2 in next move. This move would set something in between - also horrible, would mean immediate loss too.
        if case let .set(to) = blackMove {
            XCTAssertNotEqual(to, Square(column: 3, line: 1))
        }

        // that move looks good, maybe another number of pieces is even better
        XCTAssertEqual(blackMove, .drag(from: Square(column: 3, line: 2), to: Square(column: 3, line:1), numberOfPieces: 1))
    }

    func testPerformanceExample() {
        // given
        let board = Board()
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 0), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 1, line: 1), .black)
        board.setTurnDirectly(.white)
        let computerPlayer = MonteCarloPlayer.beginner

        // when
        self.measure {
            let whiteMove = computerPlayer.bestMove(board) // easy win - should be super fast
            guard case let .drag(_, _, numberOfPieces) = whiteMove else {
                XCTFail()
                return
            }
            XCTAssert(numberOfPieces == 4)
        }
    }

    func testBestMoveIsPassForIfNoMoveIsPossible() {
        let board = Board()

        // given all 20 white pieces are set:
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 0), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 1), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 2), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 3), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(Square(column: 0, line: 4), .white, .white, .white, .white)
        let computerPlayer = MonteCarloPlayer.beginner

        let bestMove = computerPlayer.bestMove(board)
        XCTAssertEqual(bestMove, .pass)
    }
}

