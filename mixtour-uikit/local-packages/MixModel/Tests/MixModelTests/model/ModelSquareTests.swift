//
//  ModelSquareTests.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 26/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation
import XCTest
import Core
@testable import MixModel

class ModelSquareTests : XCTestCase {
    
    func testCoreSquare() {
        let modelSquare = ModelSquare(column: 5, line: 3)
        let coreSquare = modelSquare.coreSquare()
        XCTAssertEqual(modelSquare.line, Int(coreSquare.line))
        XCTAssertEqual(modelSquare.column, Int(coreSquare.column))
    }
    
    func testInitWithCoreSquare() {
        let coreSquare = MIXCoreSquare(column: 7, line: 11)
        let modelSquare = ModelSquare(coreSquare: coreSquare)
        XCTAssertEqual(modelSquare.line, Int(coreSquare.line))
        XCTAssertEqual(modelSquare.column, Int(coreSquare.column))
    }
    
    func testEquality() {
        var square1 = ModelSquare(column: 4, line: 3)
        var square2 = ModelSquare(column: 4, line: 4)
        XCTAssertNotEqual(square1, square2)
        
        square2.line = 3
        XCTAssertEqual(square1, square2)
        
        square1.column = 3
        XCTAssertNotEqual(square1, square2)
    }
}