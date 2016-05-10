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
        board.setPiecesDirectlyToSquare(ModelSquare(column: 1, line: 0), .White, .White, .White, .White)
        board.setPiecesDirectlyToSquare(ModelSquare(column: 1, line: 1), .Black)
        board.setTurnDirectly(.Black)
        
        // when
        let blackMove = board.bestMove()
        
        // assert
        XCTAssert(blackMove?.numberOfPieces != 4)
    }

}

