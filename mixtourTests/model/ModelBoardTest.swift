//
//  ModelBoardTest.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 23/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation
import XCTest

class ModelBoardTest : XCTest {
    
    func testInit() {
        let modelBoard = MIXModelBoard()
        
        XCTAssertEqual(modelBoard.playerOnTurn().value, MIXCorePlayerWhite.value, "White should start game");
        XCTAssertEqual(modelBoard.numberOfPiecesForPlayer(MIXCorePlayerWhite), UInt(20), "20 pieces at the start");
        XCTAssertEqual(modelBoard.numberOfPiecesForPlayer(MIXCorePlayerBlack), UInt(20), "20 pieces at the start");
        
        for i in 0..<5 {
            for j in 0..<5 {
                let square = MIXCoreSquareMake(UInt8(i), UInt8(j));
                XCTAssertTrue(modelBoard.isSquareEmpty(square), "at the the start everything is empty");
                XCTAssertEqual(modelBoard.heightOfSquare(MIXCoreSquareMake(UInt8(i), UInt8(j))), UInt(0), "at the start everything should be empty");
            }
        }
    }
}

