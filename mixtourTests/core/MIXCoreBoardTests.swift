//
//  MIXCoreBoardTests.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 30/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import XCTest
@testable import mixtour

class MIXCoreBoardTests : XCTestCase {
    
    func testBoard() {
        // Not sure about the difference between strideof and sizeof. Currently Swift documention is not clear enough about it. So better use both in unit test - 60 bytes for C struct!

        let letStruct : MIXCoreBoard = MIXCoreBoard()
        XCTAssertEqual(64, sizeofValue(letStruct))
        XCTAssertEqual(64, strideofValue(letStruct))
    }
}

