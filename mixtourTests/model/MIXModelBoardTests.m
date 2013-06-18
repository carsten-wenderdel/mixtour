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


- (void)testInit {
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

- (void)testSetPiece {
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    
    MIXCoreSquare square1 = MIXCoreSquareMake(1, 3);
    MIXCoreSquare square2 = MIXCoreSquareMake(2, 3);
    MIXCoreSquare square3 = MIXCoreSquareMake(3, 3);
    
    XCTAssertTrue([board setPiece:square1], @"this should be empty and therefore legal");
    XCTAssertTrue([board setPiece:square2], @"this should be empty and therefore legal");
    XCTAssertFalse([board setPiece:square1], @"There should already be a piece");
    XCTAssertTrue([board setPiece:square3], @"this should be empty and therefore legal");
    
    XCTAssertEquals([board numberOfPiecesForPlayer:MIXCorePlayerWhite], 23u, @"two pieces set");
    XCTAssertEquals([board numberOfPiecesForPlayer:MIXCorePlayerBlack], 24u,
                    @"only one piece set, one move attempt was illegal");
    
    XCTAssertEquals([board heightOfSquare:square2], 1u, @"one piece set -> height 1");
    XCTAssertEquals([board heightOfSquare:square1], 1u, @"you can only set once -> height 1");
    XCTAssertEquals([board heightOfSquare:MIXCoreSquareMake(0, 0)], 0u, @"nothing set here");
}

@end
