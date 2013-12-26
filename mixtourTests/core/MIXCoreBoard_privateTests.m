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
    
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)20u, @"");
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)20u, @"");
    XCTAssertEqual(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    
    MIXCoreSquare square = MIXCoreSquareMake(1, 1);
    setPiecesDirectly(&coreBoard, square, 1, MIXCorePlayerBlack);
    
    XCTAssertEqual(heightOfSquare(&coreBoard, square), (uint8_t)1, @"");
    XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square, 0), MIXCorePlayerBlack, @"");
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            MIXCoreSquare testSquare = MIXCoreSquareMake(i, j);
            if (testSquare.column != square.column || testSquare.line != square.line) {
                XCTAssertEqual(heightOfSquare(&coreBoard, testSquare), (uint8_t)0, @"");
            }
        }
    }
    
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)20u, @"");
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)19u, @"");
    XCTAssertEqual(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    
    MIXCoreSquare square2 = MIXCoreSquareMake(2, 2);
    setPiecesDirectly(&coreBoard, square2, 3, MIXCorePlayerBlack, MIXCorePlayerWhite, MIXCorePlayerBlack);
    
    XCTAssertEqual(heightOfSquare(&coreBoard, square2), (uint8_t)3, @"");
    XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 0), MIXCorePlayerBlack, @"");
    XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 1), MIXCorePlayerWhite, @"");
    XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 2), MIXCorePlayerBlack, @"");
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)19u, @"");
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)17u, @"");
    XCTAssertEqual(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    
    setPiecesDirectly(&coreBoard, square2, 3, MIXCorePlayerBlack, MIXCorePlayerBlack, MIXCorePlayerWhite);
    
    XCTAssertEqual(heightOfSquare(&coreBoard, square2), (uint8_t)6, @"");
    XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 0), MIXCorePlayerWhite, @"");
    XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 1), MIXCorePlayerBlack, @"");
    XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 2), MIXCorePlayerBlack, @"");
    XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 3), MIXCorePlayerBlack, @"");
    XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 4), MIXCorePlayerWhite, @"");
    XCTAssertEqual(colorOfSquareAtPosition(&coreBoard, square2, 5), MIXCorePlayerBlack, @"");
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)18u, @"");
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)15u, @"");
    XCTAssertEqual(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            MIXCoreSquare testSquare = MIXCoreSquareMake(i, j);
            if ((testSquare.column != square.column || testSquare.line != square.line)
                    && (testSquare.column != square2.column || testSquare.line != square2.line)) {
                XCTAssertEqual(heightOfSquare(&coreBoard, testSquare), (uint8_t)0, @"");
            }
        }
    }
}


- (void)testSetTurnDirectly {
    
    struct MIXCoreBoard coreBoard;
    resetCoreBoard(&coreBoard);
    
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)20u, @"");
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)20u, @"");
    
    XCTAssertEqual(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    setTurnDirectly(&coreBoard, MIXCorePlayerWhite);
    XCTAssertEqual(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    
    // Usually white makes the first move.
    // Lets see whether everything is consistent when black starts
    setTurnDirectly(&coreBoard, MIXCorePlayerBlack);
    XCTAssertEqual(playerOnTurn(&coreBoard), MIXCorePlayerBlack, @"");
    
    setPiece(&coreBoard, MIXCoreSquareMake(0, 0));
    XCTAssertEqual(playerOnTurn(&coreBoard), MIXCorePlayerWhite, @"");
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerWhite), (uint8_t)20, @"");
    XCTAssertEqual(numberOfPiecesForPlayer(&coreBoard, MIXCorePlayerBlack), (uint8_t)19, @"");
}


@end
