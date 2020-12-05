//
//  MIXCoreBoard_privateTests.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 30/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import XCTest
import Core
@testable import mixtour

class MIXCoreBoard_privateTests : XCTestCase {
    
    func testSetPiecesDirectly() {
        
        var coreBoard = MIXCoreBoard()
        resetCoreBoard(&coreBoard)
        
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(20))
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(20))
        XCTAssertEqual(playerOnTurn(&coreBoard).rawValue, MIXCorePlayerWhite.rawValue)
        
        let square = MIXCoreSquare(column:1, line:1)
        setPiecesDirectlyWithList(&coreBoard, square, 1, getVaList([MIXCorePlayerBlack.rawValue]))
        
        XCTAssertEqual(heightOfSquare(&coreBoard, square), UInt8(1))
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square, 0).rawValue, MIXCorePlayerBlack.rawValue)
        for i in 0..<5 {
            for j in 0..<5 {
                let testSquare = MIXCoreSquare(column:UInt8(i), line: UInt8(j))
                if (testSquare.column != square.column || testSquare.line != square.line) {
                    XCTAssertEqual(heightOfSquare(&coreBoard, testSquare), UInt8(0))
                }
            }
        }
        
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(20))
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(19))
        XCTAssertEqual(playerOnTurn(&coreBoard).rawValue, MIXCorePlayerWhite.rawValue)
        
        let square2 = MIXCoreSquare(column: 2, line: 2)
        Core.setPiecesDirectlyWithList(&coreBoard, square2, 3, getVaList([MIXCorePlayerBlack.rawValue, MIXCorePlayerWhite.rawValue, MIXCorePlayerBlack.rawValue]))
        
        XCTAssertEqual(heightOfSquare(&coreBoard, square2), UInt8(3))
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 0).rawValue, MIXCorePlayerBlack.rawValue)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 1).rawValue, MIXCorePlayerWhite.rawValue)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 2).rawValue, MIXCorePlayerBlack.rawValue)
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(19))
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(17))
        XCTAssertEqual(playerOnTurn(&coreBoard).rawValue, MIXCorePlayerWhite.rawValue)
        
        Core.setPiecesDirectlyWithList(&coreBoard, square2, 3, getVaList([MIXCorePlayerBlack.rawValue, MIXCorePlayerBlack.rawValue, MIXCorePlayerWhite.rawValue]))
        
        XCTAssertEqual(heightOfSquare(&coreBoard, square2), UInt8(6))
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 0).rawValue, MIXCorePlayerWhite.rawValue)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 1).rawValue, MIXCorePlayerBlack.rawValue)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 2).rawValue, MIXCorePlayerBlack.rawValue)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 3).rawValue, MIXCorePlayerBlack.rawValue)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 4).rawValue, MIXCorePlayerWhite.rawValue)
        XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 5).rawValue, MIXCorePlayerBlack.rawValue)
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(18))
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(15))
        XCTAssertEqual(playerOnTurn(&coreBoard).rawValue, MIXCorePlayerWhite.rawValue)
        
        for i in 0..<5 {
            for j in 0..<5 {
                let testSquare = MIXCoreSquare(column: UInt8(i), line: UInt8(j))
                if ((testSquare.column != square.column || testSquare.line != square.line)
                    && (testSquare.column != square2.column || testSquare.line != square2.line)) {
                        XCTAssertEqual(heightOfSquare(&coreBoard, testSquare), UInt8(0))
                }
            }
        }
    }
    
    
    func testSetTurnDirectly() {
        
        var coreBoard = MIXCoreBoard()
        resetCoreBoard(&coreBoard)
        
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(20))
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(20))
        
        XCTAssertEqual(playerOnTurn(&coreBoard).rawValue, MIXCorePlayerWhite.rawValue)
        setTurnDirectly(&coreBoard, MIXCorePlayerWhite)
        XCTAssertEqual(playerOnTurn(&coreBoard).rawValue, MIXCorePlayerWhite.rawValue)
        
        // Usually white makes the first move.
        // Lets see whether everything is consistent when black starts
        setTurnDirectly(&coreBoard, MIXCorePlayerBlack)
        XCTAssertEqual(playerOnTurn(&coreBoard).rawValue, MIXCorePlayerBlack.rawValue)
        
        makeMove(&coreBoard, MIXCoreMoveMakeSet(MIXCoreSquare(column: 0, line: 0)))
        XCTAssertEqual(playerOnTurn(&coreBoard).rawValue, MIXCorePlayerWhite.rawValue)
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), UInt8(20))
        XCTAssertEqual(Core.numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), UInt8(19))
    }
    
}
