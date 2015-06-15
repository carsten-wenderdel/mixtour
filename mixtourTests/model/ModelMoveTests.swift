//
//  ModelMoveTests.swift
//  mixtour
//
//  Created by Carsten Wenderdel on 2015-04-02.
//  Copyright (c) 2015 Carsten Wenderdel. All rights reserved.
//

import XCTest
@testable import mixtour

class ModelMoveTests: XCTestCase {

    func testDragMoveModelToCore() {
        let fromSquare = ModelSquare(column: 3, line: 2)
        let toSquare = ModelSquare(column: 4, line: 1)
        let move = ModelMove(from: fromSquare, to: toSquare)
        
        XCTAssert(move.isMoveDrag())

        let coreMove = move.coreMove()
        XCTAssert(isMoveDrag(coreMove))
        
        XCTAssertEqual(coreMove.from.column, 3)
        XCTAssertEqual(coreMove.from.line, 2)
        XCTAssertEqual(coreMove.to.column, 4)
        XCTAssertEqual(coreMove.to.line, 1)
    }
    
    func testSetMoveModelToCore() {
        let toSquare = ModelSquare(column: 1, line: 4)
        let move = ModelMove(setPieceTo: toSquare)

        XCTAssertFalse(move.isMoveDrag())

        let coreMove = move.coreMove()
        XCTAssertFalse(isMoveDrag(coreMove))

        XCTAssertEqual(coreMove.to.column, 1)
        XCTAssertEqual(coreMove.to.line, 4)
    }
    
    func testDragMoveCoreToModel() {
        let coreSquareFrom = MIXCoreSquareMake(3, 2)
        let coreSquareTo = MIXCoreSquareMake(4, 1)
        let coreMove = MIXCoreMoveMakeDrag(coreSquareFrom, coreSquareTo)
        
        XCTAssert(isMoveDrag(coreMove))
    
        let move = ModelMove(coreMove: coreMove)
        XCTAssert(move.isMoveDrag())
        
        XCTAssertEqual(move.from.column, 3)
        XCTAssertEqual(move.from.line, 2)
        XCTAssertEqual(move.to.column, 4)
        XCTAssertEqual(move.to.line, 1)
    }
    
    func testSetMoveCoreToModel() {
        let coreSquareTo = MIXCoreSquareMake(2, 4)
        let coreMove = MIXCoreMoveMakeSet(coreSquareTo)
        
        XCTAssertFalse(isMoveDrag(coreMove))
        
        let move = ModelMove(coreMove: coreMove)
        XCTAssertFalse(move.isMoveDrag())
        
        XCTAssertEqual(move.to.column, 2)
        XCTAssertEqual(move.to.line, 4)
    }
}
