//
//  ModelMoveTests.swift
//  mixtour
//
//  Created by Carsten Wenderdel on 2015-04-02.
//  Copyright (c) 2015 Carsten Wenderdel. All rights reserved.
//

import XCTest
import Core
@testable import mixtour

class ModelMoveTests: XCTestCase {

    func testDragMoveModelToCore() {
        let fromSquare = ModelSquare(column: 3, line: 2)
        let toSquare = ModelSquare(column: 4, line: 1)
        let move = ModelMove(from: fromSquare, to: toSquare, numberOfPieces: 1)
        
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
        let coreSquareFrom = MIXCoreSquare(column: 3, line: 2)
        let coreSquareTo = MIXCoreSquare(column:4, line: 1)
        let coreMove = MIXCoreMoveMakeDrag(coreSquareFrom, coreSquareTo, 1)
        
        XCTAssert(isMoveDrag(coreMove))
    
        let move = ModelMove(coreMove: coreMove)
        XCTAssert(move.isMoveDrag())
        
        XCTAssertEqual(move.from.column, 3)
        XCTAssertEqual(move.from.line, 2)
        XCTAssertEqual(move.to.column, 4)
        XCTAssertEqual(move.to.line, 1)
    }
    
    func testSetMoveCoreToModel() {
        let coreSquareTo = MIXCoreSquare(column: 2, line: 4)
        let coreMove = MIXCoreMoveMakeSet(coreSquareTo)
        
        XCTAssertFalse(isMoveDrag(coreMove))
        
        let move = ModelMove(coreMove: coreMove)
        XCTAssertFalse(move.isMoveDrag())
        
        XCTAssertEqual(move.to.column, 2)
        XCTAssertEqual(move.to.line, 4)
    }
    
    func testEqualityForSetting() {
        let setMove1a = ModelMove(setPieceTo: ModelSquare(column: 1, line: 1))
        let setMove1b = ModelMove(setPieceTo: ModelSquare(column: 1, line: 1))
        let setMove2 = ModelMove(setPieceTo: ModelSquare(column: 1, line: 2))
        
        XCTAssertEqual(setMove1a, setMove1b)
        XCTAssertNotEqual(setMove1a, setMove2)
    }
    
    func testEqualityForSettingWithDifferentNonImportantInstanceVariables() {
        let setMove1a = ModelMove(setPieceTo: ModelSquare(column: 1, line: 1))
        
        var setMove1b = ModelMove(setPieceTo: ModelSquare(column: 1, line: 1))
        setMove1b.from = ModelSquare(column: 3, line: 4)
        setMove1b.numberOfPieces = 55
        
        XCTAssertEqual(setMove1a, setMove1b)
    }
    
    func testEqualityForDragging() {
        let square1 = ModelSquare(column: 1, line: 1)
        let square2 = ModelSquare(column: 2, line: 2)
        
        let dragMove1a = ModelMove(from: square1, to: square2, numberOfPieces: 1)
        let dragMove1b = ModelMove(from: square1, to: square2, numberOfPieces: 1)
        let dragMove2 = ModelMove(from: square1, to: square2, numberOfPieces: 2)
        let dragMove3 = ModelMove(from: square2, to: square1, numberOfPieces: 1)
        
        XCTAssertEqual(dragMove1a, dragMove1b)
        XCTAssertNotEqual(dragMove1a, dragMove2)
        XCTAssertNotEqual(dragMove1a, dragMove3)
    }
}
