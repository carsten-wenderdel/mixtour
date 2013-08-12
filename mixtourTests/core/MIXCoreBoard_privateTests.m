//
//  MIXCoreBoard_privateTests.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-07-27.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "MixCoreBoard_private.h"


@interface MIXCoreBoard_privateTests : XCTestCase

@end

@implementation MIXCoreBoard_privateTests

- (void)testSetPiecesDirectly {
    
    struct MIXCoreBoard coreBoard;
    resetCoreBoard(&coreBoard);
    
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)20u, @"");
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)20u, @"");
    XCTAssertEquals(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    
    MIXCoreSquare square = MIXCoreSquareMake(1, 1);
    setPiecesDirectly(&coreBoard, square, 1, MIXCorePlayerBlack);
    
    XCTAssertEquals(heightOfSquare(&coreBoard, square), (uint8_t)1, @"");
    XCTAssertEquals(colorOfSquareAtPosition(&coreBoard, square, 0), MIXCorePlayerBlack, @"");
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            MIXCoreSquare testSquare = MIXCoreSquareMake(i, j);
            if (testSquare.column != square.column || testSquare.line != square.line) {
                XCTAssertEquals(heightOfSquare(&coreBoard, testSquare), (uint8_t)0, @"");
            }
        }
    }
    
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)20u, @"");
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)19u, @"");
    XCTAssertEquals(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    
    MIXCoreSquare square2 = MIXCoreSquareMake(2, 2);
    setPiecesDirectly(&coreBoard, square2, 3, MIXCorePlayerBlack, MIXCorePlayerWhite, MIXCorePlayerBlack);
    
    XCTAssertEquals(heightOfSquare(&coreBoard, square2), (uint8_t)3, @"");
    XCTAssertEquals(colorOfSquareAtPosition(&coreBoard, square2, 0), MIXCorePlayerBlack, @"");
    XCTAssertEquals(colorOfSquareAtPosition(&coreBoard, square2, 1), MIXCorePlayerWhite, @"");
    XCTAssertEquals(colorOfSquareAtPosition(&coreBoard, square2, 2), MIXCorePlayerBlack, @"");
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)19u, @"");
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)17u, @"");
    XCTAssertEquals(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    
    setPiecesDirectly(&coreBoard, square2, 3, MIXCorePlayerBlack, MIXCorePlayerBlack, MIXCorePlayerWhite);
    
    XCTAssertEquals(heightOfSquare(&coreBoard, square2), (uint8_t)6, @"");
    XCTAssertEquals(colorOfSquareAtPosition(&coreBoard, square2, 0), MIXCorePlayerWhite, @"");
    XCTAssertEquals(colorOfSquareAtPosition(&coreBoard, square2, 1), MIXCorePlayerBlack, @"");
    XCTAssertEquals(colorOfSquareAtPosition(&coreBoard, square2, 2), MIXCorePlayerBlack, @"");
    XCTAssertEquals(colorOfSquareAtPosition(&coreBoard, square2, 3), MIXCorePlayerBlack, @"");
    XCTAssertEquals(colorOfSquareAtPosition(&coreBoard, square2, 4), MIXCorePlayerWhite, @"");
    XCTAssertEquals(colorOfSquareAtPosition(&coreBoard, square2, 5), MIXCorePlayerBlack, @"");
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)18u, @"");
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)15u, @"");
    XCTAssertEquals(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            MIXCoreSquare testSquare = MIXCoreSquareMake(i, j);
            if ((testSquare.column != square.column || testSquare.line != square.line)
                    && (testSquare.column != square2.column || testSquare.line != square2.line)) {
                XCTAssertEquals(heightOfSquare(&coreBoard, testSquare), (uint8_t)0, @"");
            }
        }
    }
}


- (void)testSetTurnDirectly {
    
    struct MIXCoreBoard coreBoard;
    resetCoreBoard(&coreBoard);
    
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)20u, @"");
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)20u, @"");
    
    XCTAssertEquals(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    setTurnDirectly(&coreBoard, MIXCorePlayerWhite);
    XCTAssertEquals(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    
    // Usually white makes the first move.
    // Lets see whether everything is consistent when black starts
    setTurnDirectly(&coreBoard, MIXCorePlayerBlack);
    XCTAssertEquals(playerOnTurn(&coreBoard), MIXCorePlayerBlack, @"");
    
    setPiece(&coreBoard, MIXCoreSquareMake(0, 0));
    XCTAssertEquals(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)20, @"");
    XCTAssertEquals(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)19, @"");
}


@end
