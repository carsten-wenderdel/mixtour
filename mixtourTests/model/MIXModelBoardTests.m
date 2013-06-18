//
//  MIXModelBoardTests.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-18.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MIXModelBoard.h"

@interface MIXModelBoardTests : XCTestCase

@end

@implementation MIXModelBoardTests


- (void)testInit
{
    MIXModelBoard *modelBoard = [[MIXModelBoard alloc] init];

    XCTAssertEquals([modelBoard playerOnTurn], MIXCorePlayerWhite, @"White should start game");
    XCTAssertEquals([modelBoard numberOfPiecesForPlayer:MIXCorePlayerWhite], 25u, @"25 pieces at the start");
    XCTAssertEquals([modelBoard numberOfPiecesForPlayer:MIXCorePlayerBlack], 25u, @"25 pieces at the start");
    for (uint8_t i = 0; i < 5; i++) {
        for (uint8_t j = 0; j < 5; j++) {
            MIXCoreSquare square = MIXCoreSquareMake(i, j);
            XCTAssertTrue([modelBoard isSquareEmpty:square], @"at the the start everything is empty");
            XCTAssertEquals([modelBoard heightOfSquare:MIXCoreSquareMake(i, j)], 0u, @"at the start everything should be empty");
        }
    }
}

@end
