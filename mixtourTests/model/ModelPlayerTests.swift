//
//  ModelPlayerTests.swift
//  mixtour
//
//  Created by Wenderdel, Carsten on 25/12/14.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

import XCTest

class ModelPlayerTests : XCTestCase {

    func testEnumValuesMatchCoreCEnum() {
        XCTAssertEqual(ModelPlayer.White.rawValue, Int(MIXCorePlayerWhite.value))
        XCTAssertEqual(ModelPlayer.Black.rawValue, Int(MIXCorePlayerBlack.value))
        XCTAssertEqual(ModelPlayer.Undefined.rawValue, Int(MIXCorePlayerUndefined.value))
    }
    
    func testInitWorksForAllCoreValues() {
        XCTAssertEqual(ModelPlayer(corePlayer: MIXCorePlayerWhite), ModelPlayer.White)
        XCTAssertEqual(ModelPlayer(corePlayer: MIXCorePlayerBlack), ModelPlayer.Black)
        XCTAssertEqual(ModelPlayer(corePlayer: MIXCorePlayerUndefined), ModelPlayer.Undefined)
    }
}

