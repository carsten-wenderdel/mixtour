import XCTest
@testable import MixModel

class ModelBoardAITests: XCTestCase {
    
    func testAIPlayerDoesNotMakeOpponentWin() {
        // given
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(ModelSquare(column: 1, line: 0), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 1, line: 1), .black)
        board.setTurnDirectly(.black)
        
        // when
        let blackMove = board.bestMove()
        
        // assert
        XCTAssert(blackMove!.numberOfPieces != 4)
    }
    
    func testAIPlayerDoesNotMakeOpponentWin2() {
        // given
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(ModelSquare(column: 0, line: 0), .white, .white, .white)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 0, line: 2), .white, .black)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 2, line: 0), .white)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 3, line: 2), .black, .black, .white)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 3, line: 3), .black, .white)
        board.setTurnDirectly(.black)
        
        // when
        let blackMove = board.bestMove()
        board.makeMoveIfLegal(blackMove!)
        
        // assert
        XCTAssert(board.isGameOver())
        XCTAssertEqual(board.winner(), ModelPlayer.black)
    }

    func testAIPlayerDoesNotMakeOpponentWinDirectlyButOneMoveLater() {
        // Given
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(ModelSquare(column: 0, line: 1), .white)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 2, line: 0), .black)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 2, line: 2), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 2, line: 3), .white, .black, .black, .black)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 3, line: 2), .white, .white)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 4, line: 1), .white, .black, .black, .white)
        board.setTurnDirectly(.black)

        // When
        let blackMove = board.bestMove()
        board.makeMoveIfLegal(blackMove!)

        // Then
        XCTAssertFalse(board.isGameOver())
        // Next move white will win anyway, but at least the computer player is not making the last move.
    }

    func testAIPlayerDoesNotLetOpponentWinInNextMove() {
        // given
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(ModelSquare(column: 0, line: 2), .black)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 1, line: 3), .black, .black, .black)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 2, line: 0), .white, .white, .white)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 3, line: 0), .white, .white)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 3, line: 2), .white, .black, .black, .white)
        board.setTurnDirectly(.black)
        
        // when
        let blackMove = board.bestMove()
        
        // then
        
        // Opponent could win by dragging with distance 2 in next move. This move would set something in between - also horrible, would mean immediate loss too.
        XCTAssertNotEqual(blackMove, ModelMove(setPieceTo: ModelSquare(column: 3, line: 1)))
        
        // that move looks good, maybe another number of pieces is even better
        XCTAssertEqual(blackMove, ModelMove(from: ModelSquare(column: 3, line: 2),
                                            to: ModelSquare(column: 3, line:1),
                                            numberOfPieces: 1))
    }

    func testPerformanceExample() {
        // given
        let board = ModelBoard()
        board.setPiecesDirectlyToSquare(ModelSquare(column: 1, line: 0), .white, .white, .white, .white)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 1, line: 1), .black)
        board.setTurnDirectly(.white)
        
        // when
        self.measure {
            let whiteMove = board.bestMove()    // easy win - should be super fast
            XCTAssert(whiteMove!.numberOfPieces == 4)
        }
    }
    
}

