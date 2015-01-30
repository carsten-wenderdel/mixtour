//
//  MIXCoreHelperTests.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 30/01/15.
//  Copyright (c) 2015 Carsten Wenderdel. All rights reserved.
//

import XCTest

class MIXCoreHelperTests : XCTestCase {
    
    func testSignum() {
    XCTAssertEqual(signum(-3), Int32(-1))
    XCTAssertEqual(signum(-1), Int32(-1))
    XCTAssertEqual(signum(0), Int32(0))
    XCTAssertEqual(signum(1), Int32(1))
    XCTAssertEqual(signum(3), Int32(1))
    }
}

