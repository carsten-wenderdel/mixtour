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


- (void)testColorAtPosition {
    
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    
    MIXCoreSquare square0 = MIXCoreSquareMake(0, 3);
    MIXCoreSquare square1 = MIXCoreSquareMake(1, 3);
    MIXCoreSquare square2 = MIXCoreSquareMake(2, 3);
    MIXCoreSquare square3 = MIXCoreSquareMake(3, 3);
    MIXCoreSquare square4 = MIXCoreSquareMake(4, 3);

    [board setPiece:square0]; // white
    [board setPiece:square1]; // black
    [board setPiece:square2]; // white
    [board setPiece:square3]; // black
    [board setPiece:square4]; // white
    
    XCTAssertEquals([board colorOfSquare:square0 atPosition:0u], MIXCorePlayerWhite, @"");
    XCTAssertEquals([board colorOfSquare:square1 atPosition:0u], MIXCorePlayerBlack, @"");
    XCTAssertEquals([board colorOfSquare:square2 atPosition:0u], MIXCorePlayerWhite, @"");
    XCTAssertEquals([board colorOfSquare:square3 atPosition:0u], MIXCorePlayerBlack, @"");
    XCTAssertEquals([board colorOfSquare:square4 atPosition:0u], MIXCorePlayerWhite, @"");
    
    [board movePieceFrom:square1 to:square0 withNumber:1u];
    [board movePieceFrom:square4 to:square3 withNumber:1u];
    [board movePieceFrom:square3 to:square2 withNumber:2u];
    [board movePieceFrom:square2 to:square0 withNumber:2u];
    
    XCTAssertEquals([board colorOfSquare:square0 atPosition:3u], MIXCorePlayerWhite, @"here from the beginning");
    XCTAssertEquals([board colorOfSquare:square0 atPosition:2u], MIXCorePlayerBlack, @"originally at square1");
    XCTAssertEquals([board colorOfSquare:square0 atPosition:1u], MIXCorePlayerBlack, @"originally at square3");
    XCTAssertEquals([board colorOfSquare:square0 atPosition:0u], MIXCorePlayerWhite, @"originally at square4");
    XCTAssertEquals([board colorOfSquare:square2 atPosition:0u], MIXCorePlayerWhite, @"here from the beginning");
    
    NSLog(@"bla");
}


@end
