//
//  ModelBoardTests.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 23/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import XCTest

class ModelBoardTests : XCTestCase {
    
    func testInit() {
        let modelBoard = ModelBoard()
        
        XCTAssertEqual(modelBoard.playerOnTurn(), ModelPlayer.White, "White should start game")
        XCTAssertEqual(modelBoard.numberOfPiecesForPlayer(ModelPlayer.White), 20, "20 pieces at the start")
        XCTAssertEqual(modelBoard.numberOfPiecesForPlayer(ModelPlayer.Black), 20, "20 pieces at the start")
        
        for i in 0..<5 {
            for j in 0..<5 {
                let square = ModelSquare(column: i, line: j)
                XCTAssertTrue(modelBoard.isSquareEmpty(square), "at the the start everything is empty")
                XCTAssertEqual(modelBoard.heightOfSquare(square), 0, "at the start everything should be empty")
            }
        }
    }
    
    
    func testGameOver() {
        let board = ModelBoard()
        XCTAssertFalse(board.isGameOver(), "")
        
        board.setPiece(ModelSquare(column: 0, line: 0))
        for i in 1..<5 {
            XCTAssertFalse(board.isGameOver(), "")
            let oldSquare = ModelSquare(column: 0, line: i - 1)
            let newSquare = ModelSquare(column: 0, line: i)
            board.setPiece(newSquare)
            board.dragPiecesFrom(oldSquare, to: newSquare, withNumber: i)
        }
        XCTAssertTrue(board.isGameOver(), "")
    }
    
    
    func testWinner() {
        var board = ModelBoard()
        XCTAssertEqual(board.winner(), ModelPlayer.Undefined)
        
        board.setPiece(ModelSquare(column: 0, line: 0))
        for i in 1..<5 {
            XCTAssertEqual(board.winner(), ModelPlayer.Undefined)
            let oldSquare = ModelSquare(column: 0, line: i - 1)
            let newSquare = ModelSquare(column: 0, line: i)
            board.setPiece(newSquare)
            board.dragPiecesFrom(oldSquare, to:newSquare, withNumber:i)
        }
        
        XCTAssertEqual(board.winner(), ModelPlayer.White)
        
        // and now the same, but place one additional piece at the beginning somewhere else.
        board = ModelBoard()
        board.setPiece(ModelSquare(column: 3, line: 3))
        board.setPiece(ModelSquare(column: 0, line: 0))
        for i in 1..<5 {
            let oldSquare = ModelSquare(column: 0, line: i - 1)
            let newSquare = ModelSquare(column: 0, line: i)
            board.setPiece(newSquare)
            board.dragPiecesFrom(oldSquare, to:newSquare, withNumber:i)
        }
        
        XCTAssertEqual(board.winner(), ModelPlayer.Black)
    }
    
    
    func testPlayerOnTurn() {
        let board = ModelBoard()
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.White)
        
        board.setPiece(ModelSquare(column: 1, line: 1))
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.Black)
        
        board.setPiece(ModelSquare(column: 1, line: 2))
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.White)
        
        board.setPiece(ModelSquare(column: 2, line: 2))
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.Black)
        
        board.dragPiecesFrom(ModelSquare(column: 1, line: 1), to:ModelSquare(column: 1, line: 2), withNumber:1)
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.White)
        
        board.dragPiecesFrom(ModelSquare(column: 2, line: 2), to:ModelSquare(column: 1, line: 2), withNumber:1)
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.White, "illegal move, turn stays")
        
        board.dragPiecesFrom(ModelSquare(column: 1, line: 2), to:ModelSquare(column: 2, line: 2), withNumber:1)
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.Black)
    }
    
    func testSetPiece() {
        let board = ModelBoard()
        
        let square1 = ModelSquare(column: 1, line: 3)
        let square2 = ModelSquare(column: 2, line: 3)
        let square3 = ModelSquare(column: 3, line: 3)
        
        XCTAssertTrue(board.setPiece(square1), "this should be empty and therefore legal")
        XCTAssertTrue(board.setPiece(square2), "this should be empty and therefore legal")
        XCTAssertFalse(board.setPiece(square1), "There should already be a piece")
        XCTAssertTrue(board.setPiece(square3), "this should be empty and therefore legal")
        
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.White), 18, "two pieces set")
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.Black), 19,
            "only one piece set, one move attempt was illegal")
        
        XCTAssertEqual(board.heightOfSquare(square2), 1, "one piece set -> height 1")
        XCTAssertEqual(board.heightOfSquare(square1), 1, "you can only set once -> height 1")
        XCTAssertEqual(board.heightOfSquare(ModelSquare(column: 0, line: 0)), 0, "nothing set here")
    }
    
    
    func testColorAtPosition() {
        
        let board = ModelBoard()
        
        let square0 = ModelSquare(column: 0, line: 3)
        let square1 = ModelSquare(column: 1, line: 3)
        let square2 = ModelSquare(column: 2, line: 3)
        let square3 = ModelSquare(column: 3, line: 3)
        let square4 = ModelSquare(column: 4, line: 3)
        
        board.setPiece(square0) // white
        board.setPiece(square1) // black
        board.setPiece(square2) // white
        board.setPiece(square3) // black
        board.setPiece(square4) // white
        
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:0), ModelPlayer.White)
        XCTAssertEqual(board.colorOfSquare(square1, atPosition:0), ModelPlayer.Black)
        XCTAssertEqual(board.colorOfSquare(square2, atPosition:0), ModelPlayer.White)
        XCTAssertEqual(board.colorOfSquare(square3, atPosition:0), ModelPlayer.Black)
        XCTAssertEqual(board.colorOfSquare(square4, atPosition:0), ModelPlayer.White)
        
        board.dragPiecesFrom(square1, to:square0, withNumber:1)
        board.dragPiecesFrom(square4, to:square3, withNumber:1)
        board.dragPiecesFrom(square3, to:square2, withNumber:2)
        board.dragPiecesFrom(square2, to:square0, withNumber:2) // not all!
        
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:3), ModelPlayer.White, "here from the beginning")
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:2), ModelPlayer.Black, "originally at square1")
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:1), ModelPlayer.Black, "originally at square3")
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:0), ModelPlayer.White, "originally at square4")
        XCTAssertEqual(board.colorOfSquare(square2, atPosition:0), ModelPlayer.White, "here from the beginning")
        
        NSLog("bla")
    }
    
    
    func boardForTestingMoves() -> ModelBoard {
        
        let board = ModelBoard()
        
        // from top to bottom: black, white, white on 1/1
        board.setPiece(ModelSquare(column: 1, line: 1))
        board.setPiece(ModelSquare(column: 0, line: 1))
        board.setPiece(ModelSquare(column: 0, line: 0))
        board.dragPiecesFrom(ModelSquare(column: 0, line: 1), to:ModelSquare(column: 0, line: 0), withNumber:1)
        board.dragPiecesFrom(ModelSquare(column: 0, line: 0), to:ModelSquare(column: 1, line: 1), withNumber:2)
        
        // from top to bottom: white, black, black on 4/4
        board.setPiece(ModelSquare(column: 4, line: 4))
        board.setPiece(ModelSquare(column: 2, line: 4))
        board.setPiece(ModelSquare(column: 3, line: 4))
        board.dragPiecesFrom(ModelSquare(column: 2, line: 4), to:ModelSquare(column: 3, line: 4), withNumber:1)
        board.dragPiecesFrom(ModelSquare(column: 3, line: 4), to:ModelSquare(column: 4, line: 4), withNumber:2)
        
        // from top to bottom: black, white on 1/4
        board.setPiece(ModelSquare(column: 1, line: 4))
        board.setPiece(ModelSquare(column: 2, line: 4))
        board.dragPiecesFrom(ModelSquare(column: 2, line: 4), to:ModelSquare(column: 1, line: 4), withNumber:1)
        
        // white on 0/0
        board.setPiece(ModelSquare(column: 0, line: 0))
        
        // black on 0/1
        board.setPiece(ModelSquare(column: 0, line: 1))
        
        return board;
    }
    
    
    func testHeight() {
        
        let board = boardForTestingMoves()
        
        XCTAssertEqual(board.heightOfSquare(ModelSquare(column: 1, line: 1)), 3)
        XCTAssertEqual(board.heightOfSquare(ModelSquare(column: 4, line: 4)), 3)
        XCTAssertEqual(board.heightOfSquare(ModelSquare(column: 1, line: 4)), 2)
        XCTAssertEqual(board.heightOfSquare(ModelSquare(column: 0, line: 0)), 1)
        XCTAssertEqual(board.heightOfSquare(ModelSquare(column: 3, line: 3)), 0, "nothing set here")
    }
    
    
    func testIsDragLegal() {
        
        let board = boardForTestingMoves()
        
        // legal drags:
        XCTAssert(board.isMoveLegal(ModelMove(from: ModelSquare(column: 4, line: 4), to:ModelSquare(column: 1, line: 1))))
        XCTAssert(board.isMoveLegal(ModelMove(from: ModelSquare(column: 1, line: 1), to:ModelSquare(column: 4, line: 4))))
        XCTAssert(board.isMoveLegal(ModelMove(from: ModelSquare(column: 1, line: 4), to:ModelSquare(column: 1, line: 1))))
        XCTAssert(board.isMoveLegal(ModelMove(from: ModelSquare(column: 1, line: 4), to:ModelSquare(column: 4, line: 4))))
        XCTAssert(board.isMoveLegal(ModelMove(from: ModelSquare(column: 1, line: 1), to:ModelSquare(column: 0, line: 1))))
        XCTAssert(board.isMoveLegal(ModelMove(from: ModelSquare(column: 1, line: 1), to:ModelSquare(column: 0, line: 0))))
        
        // illegal drags because of wrong height:
        XCTAssertFalse(board.isMoveLegal(ModelMove(from: ModelSquare(column: 1, line: 1), to:ModelSquare(column: 1, line: 4))))
        XCTAssertFalse(board.isMoveLegal(ModelMove(from: ModelSquare(column: 4, line: 4), to:ModelSquare(column: 1, line: 4))))
        XCTAssertFalse(board.isMoveLegal(ModelMove(from: ModelSquare(column: 0, line: 0), to:ModelSquare(column: 1, line: 1))))
        
        // put some pieces between -> legal becomes illegal
        board.setPiece(ModelSquare(column: 2, line: 2))
        XCTAssertFalse(board.isMoveLegal(ModelMove(from: ModelSquare(column: 4, line: 4), to:ModelSquare(column: 1, line: 1))))
        XCTAssertFalse(board.isMoveLegal(ModelMove(from: ModelSquare(column: 1, line: 1), to:ModelSquare(column: 4, line: 4))))
        
        board.setPiece(ModelSquare(column: 1, line: 3))
        board.setPiece(ModelSquare(column: 3, line: 4))
        (board.isMoveLegal(ModelMove(from: ModelSquare(column: 1, line: 4), to:ModelSquare(column: 1, line: 1))))
        (board.isMoveLegal(ModelMove(from: ModelSquare(column: 1, line: 4), to:ModelSquare(column: 4, line: 4))))
    }
    
    func testIsDraggingLegalCross() {
        let board = ModelBoard()
        for i in 1..<5 {
            for j in 1..<5 {
                board.setPiece(ModelSquare(column: i, line: j))
            }
        }
        let squareWithTwoPieces = ModelSquare(column: 4, line: 1)
        board.dragPiecesFrom(ModelSquare(column: 3, line: 2), to:squareWithTwoPieces, withNumber:1)
        
        XCTAssertTrue(board.isMoveLegal(ModelMove(from: ModelSquare(column: 2, line: 3), to: squareWithTwoPieces)))
    }
    
    func testIsSettingPossible() {
        
        let board = ModelBoard()
        
        // setting pieces everywhere
        for i in 0..<5 {
            for j in 0..<5 {
                XCTAssertTrue(board.isSettingPossible(), "still something free")
                board.setPiece(ModelSquare(column: i, line: j))
            }
        }
        XCTAssertFalse(board.isSettingPossible(), "all 25 squares covered")
        
        // clearing (15) squares as much as possible with the exception of j==0
        for i in 0..<5 {
            for j in 1..<4 {
                let from = ModelSquare(column: i, line: j)
                let to = ModelSquare(column: i, line: j+1)
                board.dragPiecesFrom(from, to:to, withNumber:j)
                XCTAssertTrue(board.isSettingPossible(), "")
            }
        }
        
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.White), 7, "")
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.Black), 8, "")
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.White)
        
        // setting 14 pieces on cleared squares
        for i in 0..<5 {
            for j in 1..<4 {
                if (i != 4 || j != 3) {
                    XCTAssertTrue(board.isSettingPossible(), "")
                    let square = ModelSquare(column: i, line: j)
                    XCTAssertTrue(board.isSquareEmpty(square))
                    board.setPiece(square)
                }
            }
        }
        
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.White), 0, "")
        XCTAssertEqual(board.numberOfPiecesForPlayer(ModelPlayer.Black), 1, "")
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.White)
        
        let emptySquare = ModelSquare(column: 4, line: 3)
        XCTAssertTrue(board.isSquareEmpty(emptySquare))
        XCTAssertFalse(board.isSettingPossible(), "no pieces left for white")
        
        board.dragPiecesFrom(ModelSquare(column: 1, line: 4), to:ModelSquare(column: 1, line: 3), withNumber:3)
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.Black)
        XCTAssertTrue(board.isSettingPossible(), "")
        board.setPiece(emptySquare)
        
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.White)
        XCTAssertFalse(board.isSettingPossible(), "")
        board.dragPiecesFrom(ModelSquare(column: 1, line: 3), to:ModelSquare(column: 1, line: 4), withNumber:3)
        
        XCTAssertEqual(board.playerOnTurn(), ModelPlayer.Black)
        XCTAssertFalse(board.isSettingPossible(), "no pieces left for black")
    }
    
}

