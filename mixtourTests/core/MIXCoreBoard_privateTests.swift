//
//  MIXCoreBoard_privateTests.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 30/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import XCTest

class MIXCoreBoard_privateTests : XCTestCase {
    
    func testSetPiecesDirectly() {
        
        var coreBoard =  mixtour.createNonInitializedCoreBoard()
        resetCoreBoard(&coreBoard)
        
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(20))
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(20))
        XCTAssertEqual(playerOnTurn(&coreBoard).value, MIXCorePlayerWhite.value)
        
        let square = MIXCoreSquareMake(UInt8(1), UInt8(1))
        setPiecesDirectlyWithList(&coreBoard, square, 1, getVaList([MIXCorePlayerBlack.value]))
        
        XCTAssertEqual(heightOfSquare(&coreBoard, square), UInt8(1))
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square, 0).value, MIXCorePlayerBlack.value)
        for i in 0..<5 {
            for j in 0..<5 {
                let testSquare = MIXCoreSquareMake(UInt8(i), UInt8(j))
                if (testSquare.column != square.column || testSquare.line != square.line) {
                    XCTAssertEqual(heightOfSquare(&coreBoard, testSquare), UInt8(0))
                }
            }
        }
        
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(20))
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(19))
        XCTAssertEqual(playerOnTurn(&coreBoard).value, MIXCorePlayerWhite.value)
        
        let square2 = MIXCoreSquareMake(UInt8(2), UInt8(2))
        mixtour.setPiecesDirectlyWithList(&coreBoard, square2, 3, getVaList([MIXCorePlayerBlack.value, MIXCorePlayerWhite.value, MIXCorePlayerBlack.value]))
        
        XCTAssertEqual(heightOfSquare(&coreBoard, square2), UInt8(3))
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 0).value, MIXCorePlayerBlack.value)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 1).value, MIXCorePlayerWhite.value)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 2).value, MIXCorePlayerBlack.value)
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(19))
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(17))
        XCTAssertEqual(playerOnTurn(&coreBoard).value, MIXCorePlayerWhite.value)
        
        mixtour.setPiecesDirectlyWithList(&coreBoard, square2, 3, getVaList([MIXCorePlayerBlack.value, MIXCorePlayerBlack.value, MIXCorePlayerWhite.value]))
        
        XCTAssertEqual(heightOfSquare(&coreBoard, square2), UInt8(6))
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 0).value, MIXCorePlayerWhite.value)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 1).value, MIXCorePlayerBlack.value)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 2).value, MIXCorePlayerBlack.value)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 3).value, MIXCorePlayerBlack.value)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 4).value, MIXCorePlayerWhite.value)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 5).value, MIXCorePlayerBlack.value)
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(18))
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(15))
        XCTAssertEqual(playerOnTurn(&coreBoard).value, MIXCorePlayerWhite.value)
        
        for i in 0..<5 {
            for j in 0..<5 {
                let testSquare = MIXCoreSquareMake(UInt8(i), UInt8(j))
                if ((testSquare.column != square.column || testSquare.line != square.line)
                    && (testSquare.column != square2.column || testSquare.line != square2.line)) {
                        XCTAssertEqual(heightOfSquare(&coreBoard, testSquare), UInt8(0))
                }
            }
        }
    }
    
    
    func testSetTurnDirectly() {
        
        var coreBoard =  mixtour.createNonInitializedCoreBoard()
        resetCoreBoard(&coreBoard)
        
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(20))
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(20))
        
        XCTAssertEqual(playerOnTurn(&coreBoard).value, MIXCorePlayerWhite.value)
        setTurnDirectly(&coreBoard, MIXCorePlayerWhite)
        XCTAssertEqual(playerOnTurn(&coreBoard).value, MIXCorePlayerWhite.value)
        
        // Usually white makes the first move.
        // Lets see whether everything is consistent when black starts
        setTurnDirectly(&coreBoard, MIXCorePlayerBlack)
        XCTAssertEqual(playerOnTurn(&coreBoard).value, MIXCorePlayerBlack.value)
        
        setPiece(&coreBoard, MIXCoreSquareMake(UInt8(UInt(0)), UInt8(UInt(0))))
        XCTAssertEqual(playerOnTurn(&coreBoard).value, MIXCorePlayerWhite.value)
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(20))
        XCTAssertEqual(mixtour.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(19))
    }
    
}
