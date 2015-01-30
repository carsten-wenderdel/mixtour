//
//  MIXCoreBoardTests.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 30/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import XCTest

class MIXCoreBoardTests : XCTestCase {
    
    func testBoard() {
        // Not sure about the difference between strideof and sizeof. Currently Swift documention is not clear enough about it. So better use both in unit test - 60 bytes for C struct!
        var varStruct : MIXCoreBoard = mixtour.createNonInitializedCoreBoard()
        XCTAssertEqual(60, sizeofValue(varStruct))
        XCTAssertEqual(60, strideofValue(varStruct))

        let letStruct : MIXCoreBoard = mixtour.createNonInitializedCoreBoard()
        XCTAssertEqual(60, sizeofValue(letStruct))
        XCTAssertEqual(60, strideofValue(letStruct))
    }
}

