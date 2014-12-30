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
        var varStruct : MIXCoreBoard = mixtour.createNonInitializedCoreBoard()
        XCTAssertEqual(60, sizeofValue(varStruct))

        let letStruct : MIXCoreBoard = mixtour.createNonInitializedCoreBoard()
        XCTAssertEqual(60, sizeofValue(letStruct))
    }
}

