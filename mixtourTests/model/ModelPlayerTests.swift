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
        XCTAssertEqual(mixtour.ModelPlayer(corePlayer: MIXCorePlayerWhite), ModelPlayer.White)
        XCTAssertEqual(mixtour.ModelPlayer(corePlayer: MIXCorePlayerBlack), ModelPlayer.Black)
        XCTAssertEqual(mixtour.ModelPlayer(corePlayer: MIXCorePlayerUndefined), ModelPlayer.Undefined)
    }
    
    func testCorePlayer() {
        XCTAssertEqual(ModelPlayer.White.corePlayer().value, MIXCorePlayerWhite.value)
        XCTAssertEqual(ModelPlayer.Black.corePlayer().value, MIXCorePlayerBlack.value)
        XCTAssertEqual(ModelPlayer.Undefined.corePlayer().value, MIXCorePlayerUndefined.value)

    }
}

