//
//  ModelBoardAITests.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 10/05/16.
//  Copyright © 2016 Carsten Wenderdel. All rights reserved.
//

import XCTest
@testable import mixtour


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
        board.setPiecesDirectlyToSquare(ModelSquare(column: 0, line: 0), .White, .White, .White)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 0, line: 2), .White, .Black)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 2, line: 0), .White)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 3, line: 2), .Black, .Black, .White)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 3, line: 3), .Black, .White)
        board.setTurnDirectly(.Black)
        
        // when
        let blackMove = board.bestMove()
        board.makeMoveIfLegal(blackMove!)
        
        // assert
        XCTAssert(board.isGameOver())
        XCTAssertEqual(board.winner(), ModelPlayer.Black)
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

