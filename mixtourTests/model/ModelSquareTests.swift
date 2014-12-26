//
//  ModelSquareTests.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 26/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import Foundation

import XCTest

class ModelSquareTests : XCTestCase {
    
    func testCoreSquare() {
        let modelSquare: ModelSquare = ModelSquare(column: 5, line: 3)
        let coreSquare: MIXCoreSquare = modelSquare.coreSquare()
        XCTAssertEqual(modelSquare.line, Int(coreSquare.line))
        XCTAssertEqual(modelSquare.column, Int(coreSquare.column))
    }
    
    func testInitWithCoreSquare() {
        let coreSquare: MIXCoreSquare = MIXCoreSquareMake(7, 11)
        let modelSquare: ModelSquare = ModelSquare(coreSquare: coreSquare)
        XCTAssertEqual(modelSquare.line, Int(coreSquare.line))
        XCTAssertEqual(modelSquare.column, Int(coreSquare.column))
    }
}
