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
        let modelBoard = MIXModelBoard()
        
        XCTAssertEqual(modelBoard.playerOnTurn().value, MIXCorePlayerWhite.value, "White should start game")
        XCTAssertEqual(modelBoard.numberOfPiecesForPlayer(MIXCorePlayerWhite), UInt(20), "20 pieces at the start")
        XCTAssertEqual(modelBoard.numberOfPiecesForPlayer(MIXCorePlayerBlack), UInt(20), "20 pieces at the start")
        
        for i in 0..<5 {
            for j in 0..<5 {
                let square = MIXCoreSquareMake(UInt8(i), UInt8(j))
                XCTAssertTrue(modelBoard.isSquareEmpty(square), "at the the start everything is empty")
                XCTAssertEqual(modelBoard.heightOfSquare(MIXCoreSquareMake(UInt8(i), UInt8(j))), UInt(0), "at the start everything should be empty")
            }
        }
    }
    
    
    func testGameOver() {
        let board = MIXModelBoard()
        XCTAssertFalse(board.isGameOver(), "")
        
        board.setPiece(MIXCoreSquareMake(0, 0))
        for i in 1..<5 {
            XCTAssertFalse(board.isGameOver(), "")
            let oldSquare = MIXCoreSquareMake(UInt8(0), UInt8(i - 1))
            let newSquare = MIXCoreSquareMake(UInt8(0), UInt8(i))
            board.setPiece(newSquare)
            board.dragPiecesFrom(oldSquare, to: newSquare, withNumber: UInt(i))
        }
        XCTAssertTrue(board.isGameOver(), "")
    }
    
    
    func testWinner() {
        var board = MIXModelBoard()
        XCTAssertEqual(board.winner().value, MIXCorePlayerUndefined.value, "")
        
        board.setPiece(MIXCoreSquareMake(0, 0))
        for i in 1..<5 {
            XCTAssertEqual(board.winner().value, MIXCorePlayerUndefined.value, "")
            let oldSquare = MIXCoreSquareMake(UInt8(0), UInt8(i - 1))
            let newSquare = MIXCoreSquareMake(UInt8(0), UInt8(i))
            board.setPiece(newSquare)
            board.dragPiecesFrom(oldSquare, to:newSquare, withNumber:UInt(i))
        }
        
        XCTAssertEqual(board.winner().value, MIXCorePlayerWhite.value, "")
        
        // and now the same, but place one additional piece at the beginning somewhere else.
        board = MIXModelBoard()
        board.setPiece(MIXCoreSquareMake(3, 3))
        board.setPiece(MIXCoreSquareMake(0, 0))
        for i in 1..<5 {
            let oldSquare = MIXCoreSquareMake(UInt8(0), UInt8(i - 1))
            let newSquare = MIXCoreSquareMake(UInt8(0), UInt8(i))
            board.setPiece(newSquare)
            board.dragPiecesFrom(oldSquare, to:newSquare, withNumber:UInt(i))
        }
        
        XCTAssertEqual(board.winner().value, MIXCorePlayerBlack.value, "")
    }
    
    
    func testPlayerOnTurn() {
        let board = MIXModelBoard()
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerWhite.value, "")
        
        board.setPiece(MIXCoreSquareMake(1, 1))
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerBlack.value, "")
        
        board.setPiece(MIXCoreSquareMake(1, 2))
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerWhite.value, "")
        
        board.setPiece(MIXCoreSquareMake(2, 2))
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerBlack.value, "")
        
        board.dragPiecesFrom(MIXCoreSquareMake(1, 1), to:MIXCoreSquareMake(1, 2), withNumber:1)
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerWhite.value, "")
        
        board.dragPiecesFrom(MIXCoreSquareMake(2, 2), to:MIXCoreSquareMake(1, 2), withNumber:1)
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerWhite.value, "illegal move, turn stays")
        
        board.dragPiecesFrom(MIXCoreSquareMake(1, 2), to:MIXCoreSquareMake(2, 2), withNumber:1)
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerBlack.value, "")
    }
    
    func testSetPiece() {
        let board = MIXModelBoard()
        
        let square1 = MIXCoreSquareMake(1, 3)
        let square2 = MIXCoreSquareMake(2, 3)
        let square3 = MIXCoreSquareMake(3, 3)
        
        XCTAssertTrue(board.setPiece(square1), "this should be empty and therefore legal")
        XCTAssertTrue(board.setPiece(square2), "this should be empty and therefore legal")
        XCTAssertFalse(board.setPiece(square1), "There should already be a piece")
        XCTAssertTrue(board.setPiece(square3), "this should be empty and therefore legal")
        
        XCTAssertEqual(board.numberOfPiecesForPlayer(MIXCorePlayerWhite), UInt(18), "two pieces set")
        XCTAssertEqual(board.numberOfPiecesForPlayer(MIXCorePlayerBlack), UInt(19),
            "only one piece set, one move attempt was illegal")
        
        XCTAssertEqual(board.heightOfSquare(square2), UInt(1), "one piece set -> height 1")
        XCTAssertEqual(board.heightOfSquare(square1), UInt(1), "you can only set once -> height 1")
        XCTAssertEqual(board.heightOfSquare(MIXCoreSquareMake(0, 0)), UInt(0), "nothing set here")
    }
    
    
    func testColorAtPosition() {
        
        let board = MIXModelBoard()
        
        let square0 = MIXCoreSquareMake(0, 3)
        let square1 = MIXCoreSquareMake(1, 3)
        let square2 = MIXCoreSquareMake(2, 3)
        let square3 = MIXCoreSquareMake(3, 3)
        let square4 = MIXCoreSquareMake(4, 3)
        
        board.setPiece(square0) // white
        board.setPiece(square1) // black
        board.setPiece(square2) // white
        board.setPiece(square3) // black
        board.setPiece(square4) // white
        
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:UInt8(0)).value, MIXCorePlayerWhite.value, "")
        XCTAssertEqual(board.colorOfSquare(square1, atPosition:UInt8(0)).value, MIXCorePlayerBlack.value, "")
        XCTAssertEqual(board.colorOfSquare(square2, atPosition:UInt8(0)).value, MIXCorePlayerWhite.value, "")
        XCTAssertEqual(board.colorOfSquare(square3, atPosition:UInt8(0)).value, MIXCorePlayerBlack.value, "")
        XCTAssertEqual(board.colorOfSquare(square4, atPosition:UInt8(0)).value, MIXCorePlayerWhite.value, "")
        
        board.dragPiecesFrom(square1, to:square0, withNumber:UInt(1))
        board.dragPiecesFrom(square4, to:square3, withNumber:UInt(1))
        board.dragPiecesFrom(square3, to:square2, withNumber:UInt(2))
        board.dragPiecesFrom(square2, to:square0, withNumber:UInt(2)) // not all!
        
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:UInt8(3)).value, MIXCorePlayerWhite.value, "here from the beginning")
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:UInt8(2)).value, MIXCorePlayerBlack.value, "originally at square1")
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:UInt8(1)).value, MIXCorePlayerBlack.value, "originally at square3")
        XCTAssertEqual(board.colorOfSquare(square0, atPosition:UInt8(0)).value, MIXCorePlayerWhite.value, "originally at square4")
        XCTAssertEqual(board.colorOfSquare(square2, atPosition:UInt8(0)).value, MIXCorePlayerWhite.value, "here from the beginning")
        
        NSLog("bla")
    }
    
    
    func boardForTestingMoves() -> MIXModelBoard {
        
        let board = MIXModelBoard()
        
        // from top to bottom: black, white, white on 1/1
        board.setPiece(MIXCoreSquareMake(1, 1))
        board.setPiece(MIXCoreSquareMake(0, 1))
        board.setPiece(MIXCoreSquareMake(0, 0))
        board.dragPiecesFrom(MIXCoreSquareMake(0, 1), to:MIXCoreSquareMake(0, 0), withNumber:1)
        board.dragPiecesFrom(MIXCoreSquareMake(0, 0), to:MIXCoreSquareMake(1, 1), withNumber:2)
        
        // from top to bottom: white, black, black on 4/4
        board.setPiece(MIXCoreSquareMake(4, 4))
        board.setPiece(MIXCoreSquareMake(2, 4))
        board.setPiece(MIXCoreSquareMake(3, 4))
        board.dragPiecesFrom(MIXCoreSquareMake(2, 4), to:MIXCoreSquareMake(3, 4), withNumber:1)
        board.dragPiecesFrom(MIXCoreSquareMake(3, 4), to:MIXCoreSquareMake(4, 4), withNumber:2)
        
        // from top to bottom: black, white on 1/4
        board.setPiece(MIXCoreSquareMake(1, 4))
        board.setPiece(MIXCoreSquareMake(2, 4))
        board.dragPiecesFrom(MIXCoreSquareMake(2, 4), to:MIXCoreSquareMake(1, 4), withNumber:1)
        
        // white on 0/0
        board.setPiece(MIXCoreSquareMake(0, 0))
        
        // black on 0/1
        board.setPiece(MIXCoreSquareMake(0, 1))
        
        return board;
    }
    
    
    func testHeight() {
        
        let board = boardForTestingMoves()
        
        XCTAssertEqual(board.heightOfSquare(MIXCoreSquareMake(1, 1)), UInt(3), "")
        XCTAssertEqual(board.heightOfSquare(MIXCoreSquareMake(4, 4)), UInt(3), "")
        XCTAssertEqual(board.heightOfSquare(MIXCoreSquareMake(1, 4)), UInt(2), "")
        XCTAssertEqual(board.heightOfSquare(MIXCoreSquareMake(0, 0)), UInt(1), "")
        XCTAssertEqual(board.heightOfSquare(MIXCoreSquareMake(3, 3)), UInt(0), "nothing set here")
    }
    
    
    func testIsDragLegal() {
        
        let board = boardForTestingMoves()
        
        // legal drags:
        XCTAssertTrue(board.isDragLegalFrom(MIXCoreSquareMake(4, 4), to:MIXCoreSquareMake(1, 1)), "")
        XCTAssertTrue(board.isDragLegalFrom(MIXCoreSquareMake(1, 1), to:MIXCoreSquareMake(4, 4)), "")
        XCTAssertTrue(board.isDragLegalFrom(MIXCoreSquareMake(1, 4), to:MIXCoreSquareMake(1, 1)), "")
        XCTAssertTrue(board.isDragLegalFrom(MIXCoreSquareMake(1, 4), to:MIXCoreSquareMake(4, 4)), "")
        XCTAssertTrue(board.isDragLegalFrom(MIXCoreSquareMake(1, 1), to:MIXCoreSquareMake(0, 1)), "")
        XCTAssertTrue(board.isDragLegalFrom(MIXCoreSquareMake(1, 1), to:MIXCoreSquareMake(0, 0)), "")
        
        // illegal drags because of wrong height:
        XCTAssertFalse(board.isDragLegalFrom(MIXCoreSquareMake(1, 1), to:MIXCoreSquareMake(1, 4)), "")
        XCTAssertFalse(board.isDragLegalFrom(MIXCoreSquareMake(4, 4), to:MIXCoreSquareMake(1, 4)), "")
        XCTAssertFalse(board.isDragLegalFrom(MIXCoreSquareMake(0, 0), to:MIXCoreSquareMake(1, 1)), "")
        
        // put some pieces between -> legal becomes illegal
        board.setPiece(MIXCoreSquareMake(2, 2))
        XCTAssertFalse(board.isDragLegalFrom(MIXCoreSquareMake(4, 4), to:MIXCoreSquareMake(1, 1)), "")
        XCTAssertFalse(board.isDragLegalFrom(MIXCoreSquareMake(1, 1), to:MIXCoreSquareMake(4, 4)), "")
        
        board.setPiece(MIXCoreSquareMake(1, 3))
        board.setPiece(MIXCoreSquareMake(3, 4))
        XCTAssertTrue(board.isDragLegalFrom(MIXCoreSquareMake(1, 4), to:MIXCoreSquareMake(1, 1)), "")
        XCTAssertTrue(board.isDragLegalFrom(MIXCoreSquareMake(1, 4), to:MIXCoreSquareMake(4, 4)), "")
    }
    
    func testIsDraggingLegalCross() {
        let board = MIXModelBoard()
        for i in 1..<5 {
            for j in 1..<5 {
                board.setPiece(MIXCoreSquareMake(UInt8(i), UInt8(j)))
            }
        }
        let squareWithTwoPieces = MIXCoreSquareMake(4, 1)
        board.dragPiecesFrom(MIXCoreSquareMake(3, 2), to:squareWithTwoPieces, withNumber:UInt(1))
        
        XCTAssertTrue(board.isDragLegalFrom(MIXCoreSquareMake(2, 3), to:squareWithTwoPieces), "")
    }
    
    func testIsSettingPossible() {
        
        let board = MIXModelBoard()
        
        // setting pieces everywhere
        for i in 0..<5 {
            for j in 0..<5 {
                XCTAssertTrue(board.isSettingPossible(), "still something free")
                board.setPiece(MIXCoreSquareMake(UInt8(i), UInt8(j)))
            }
        }
        XCTAssertFalse(board.isSettingPossible(), "all 25 squares covered")
        
        // clearing (15) squares as much as possible with the exception of j==0
        for i in 0..<5 {
            for j in 1..<4 {
                let from = MIXCoreSquareMake(UInt8(i), UInt8(j))
                let to = MIXCoreSquareMake(UInt8(i), UInt8(j+1))
                board.dragPiecesFrom(from, to:to, withNumber:UInt(j))
                XCTAssertTrue(board.isSettingPossible(), "")
            }
        }
        
        XCTAssertEqual(board.numberOfPiecesForPlayer(MIXCorePlayerWhite), UInt(7), "")
        XCTAssertEqual(board.numberOfPiecesForPlayer(MIXCorePlayerBlack), UInt(8), "")
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerWhite.value, "")
        
        // setting 14 pieces on cleared squares
        for i in 0..<5 {
            for j in 1..<4 {
                if (i != 4 || j != 3) {
                    XCTAssertTrue(board.isSettingPossible(), "")
                    let square = MIXCoreSquareMake(UInt8(i), UInt8(j))
                    XCTAssertTrue(board.isSquareEmpty(square))
                    board.setPiece(square)
                }
            }
        }
        
        XCTAssertEqual(board.numberOfPiecesForPlayer(MIXCorePlayerWhite), UInt(0), "")
        XCTAssertEqual(board.numberOfPiecesForPlayer(MIXCorePlayerBlack), UInt(1), "")
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerWhite.value, "")
        
        let emptySquare = MIXCoreSquareMake(4, 3)
        XCTAssertTrue(board.isSquareEmpty(emptySquare))
        XCTAssertFalse(board.isSettingPossible(), "no pieces left for white")
        
        board.dragPiecesFrom(MIXCoreSquareMake(1, 4), to:MIXCoreSquareMake(1, 3), withNumber:3)
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerBlack.value, "")
        XCTAssertTrue(board.isSettingPossible(), "")
        board.setPiece(emptySquare)
        
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerWhite.value, "")
        XCTAssertFalse(board.isSettingPossible(), "")
        board.dragPiecesFrom(MIXCoreSquareMake(1, 3), to:MIXCoreSquareMake(1, 4), withNumber:3)
        
        XCTAssertEqual(board.playerOnTurn().value, MIXCorePlayerBlack.value, "")
        XCTAssertFalse(board.isSettingPossible(), "no pieces left for black")
    }
    
}

