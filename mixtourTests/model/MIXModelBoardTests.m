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
    XCTAssertEquals([modelBoard numberOfPiecesForPlayer:MIXCorePlayerWhite], 20u, @"25 pieces at the start");
    XCTAssertEquals([modelBoard numberOfPiecesForPlayer:MIXCorePlayerBlack], 20u, @"25 pieces at the start");
    
    for (uint8_t i = 0; i < 5; i++) {
        for (uint8_t j = 0; j < 5; j++) {
            MIXCoreSquare square = MIXCoreSquareMake(i, j);
            XCTAssertTrue([modelBoard isSquareEmpty:square], @"at the the start everything is empty");
            XCTAssertEquals([modelBoard heightOfSquare:MIXCoreSquareMake(i, j)], 0u, @"at the start everything should be empty");
        }
    }
}


- (void)testGameOver {
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    XCTAssertFalseNoThrow([board isGameOver], @"");
    
    [board setPiece:MIXCoreSquareMake(0, 0)];
    for (int i = 1; i < 5; i++) {
        XCTAssertFalseNoThrow([board isGameOver], @"");
        MIXCoreSquare oldSquare = MIXCoreSquareMake(0, i - 1);
        MIXCoreSquare newSquare = MIXCoreSquareMake(0, i);
        [board setPiece:newSquare];
        [board dragPiecesFrom:oldSquare to:newSquare withNumber:i];
    }
    
    XCTAssertTrueNoThrow([board isGameOver], @"");
}


- (void)testWinner {
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    XCTAssertEquals([board winner], MIXCorePlayerUndefined, @"");
    
    [board setPiece:MIXCoreSquareMake(0, 0)];
    for (int i = 1; i < 5; i++) {
        XCTAssertEquals([board winner], MIXCorePlayerUndefined, @"");
        MIXCoreSquare oldSquare = MIXCoreSquareMake(0, i - 1);
        MIXCoreSquare newSquare = MIXCoreSquareMake(0, i);
        [board setPiece:newSquare];
        [board dragPiecesFrom:oldSquare to:newSquare withNumber:i];
    }
    
    XCTAssertEquals([board winner], MIXCorePlayerWhite, @"");
    
    // and now the same, but place one additional piece at the beginning somewhere else.
    board = [[MIXModelBoard alloc] init];
    [board setPiece:MIXCoreSquareMake(3, 3)];
    [board setPiece:MIXCoreSquareMake(0, 0)];
    for (int i = 1; i < 5; i++) {
        MIXCoreSquare oldSquare = MIXCoreSquareMake(0, i - 1);
        MIXCoreSquare newSquare = MIXCoreSquareMake(0, i);
        [board setPiece:newSquare];
        [board dragPiecesFrom:oldSquare to:newSquare withNumber:i];
    }
    
    XCTAssertEquals([board winner], MIXCorePlayerBlack, @"");
}


- (void)testPlayerOnTurn {
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    XCTAssertEquals([board playerOnTurn], MIXCorePlayerWhite, @"");
    
    [board setPiece:MIXCoreSquareMake(1, 1)];
    XCTAssertEquals([board playerOnTurn], MIXCorePlayerBlack, @"");
    
    [board setPiece:MIXCoreSquareMake(1, 2)];
    XCTAssertEquals([board playerOnTurn], MIXCorePlayerWhite, @"");
    
    [board setPiece:MIXCoreSquareMake(2, 2)];
    XCTAssertEquals([board playerOnTurn], MIXCorePlayerBlack, @"");
    
    [board dragPiecesFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(1, 2) withNumber:1];
    XCTAssertEquals([board playerOnTurn], MIXCorePlayerWhite, @"");
    
    [board dragPiecesFrom:MIXCoreSquareMake(2, 2) to:MIXCoreSquareMake(1, 2) withNumber:1];
    XCTAssertEquals([board playerOnTurn], MIXCorePlayerWhite, @"illegal move, turn stays");
    
    [board dragPiecesFrom:MIXCoreSquareMake(1, 2) to:MIXCoreSquareMake(2, 2) withNumber:1];
    XCTAssertEquals([board playerOnTurn], MIXCorePlayerBlack, @"");
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
    
    XCTAssertEquals([board numberOfPiecesForPlayer:MIXCorePlayerWhite], 18u, @"two pieces set");
    XCTAssertEquals([board numberOfPiecesForPlayer:MIXCorePlayerBlack], 19u,
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
    
    [board dragPiecesFrom:square1 to:square0 withNumber:1u];
    [board dragPiecesFrom:square4 to:square3 withNumber:1u];
    [board dragPiecesFrom:square3 to:square2 withNumber:2u];
    [board dragPiecesFrom:square2 to:square0 withNumber:2u]; // not all!
    
    XCTAssertEquals([board colorOfSquare:square0 atPosition:3u], MIXCorePlayerWhite, @"here from the beginning");
    XCTAssertEquals([board colorOfSquare:square0 atPosition:2u], MIXCorePlayerBlack, @"originally at square1");
    XCTAssertEquals([board colorOfSquare:square0 atPosition:1u], MIXCorePlayerBlack, @"originally at square3");
    XCTAssertEquals([board colorOfSquare:square0 atPosition:0u], MIXCorePlayerWhite, @"originally at square4");
    XCTAssertEquals([board colorOfSquare:square2 atPosition:0u], MIXCorePlayerWhite, @"here from the beginning");
    
    NSLog(@"bla");
}


- (MIXModelBoard *)boardForTestingMoves {
    
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    
    // from top to bottom: black, white, white on 1/1
    [board setPiece:MIXCoreSquareMake(1, 1)];
    [board setPiece:MIXCoreSquareMake(0, 1)];
    [board setPiece:MIXCoreSquareMake(0, 0)];
    [board dragPiecesFrom:MIXCoreSquareMake(0, 1) to:MIXCoreSquareMake(0, 0) withNumber:1];
    [board dragPiecesFrom:MIXCoreSquareMake(0, 0) to:MIXCoreSquareMake(1, 1) withNumber:2];
    
    // from top to bottom: white, black, black on 4/4
    [board setPiece:MIXCoreSquareMake(4, 4)];
    [board setPiece:MIXCoreSquareMake(2, 4)];
    [board setPiece:MIXCoreSquareMake(3, 4)];
    [board dragPiecesFrom:MIXCoreSquareMake(2, 4) to:MIXCoreSquareMake(3, 4) withNumber:1];
    [board dragPiecesFrom:MIXCoreSquareMake(3, 4) to:MIXCoreSquareMake(4, 4) withNumber:2];
    
    // from top to bottom: black, white on 1/4
    [board setPiece:MIXCoreSquareMake(1, 4)];
    [board setPiece:MIXCoreSquareMake(2, 4)];
    [board dragPiecesFrom:MIXCoreSquareMake(2, 4) to:MIXCoreSquareMake(1, 4) withNumber:1];
    
    // white on 0/0
    [board setPiece:MIXCoreSquareMake(0, 0)];
    
    // black on 0/1
    [board setPiece:MIXCoreSquareMake(0, 1)];
    
    return board;
}


- (void)testHeight {
    
    MIXModelBoard *board = [self boardForTestingMoves];
    
    XCTAssertEquals([board heightOfSquare:MIXCoreSquareMake(1, 1)], 3u, @"");
    XCTAssertEquals([board heightOfSquare:MIXCoreSquareMake(4, 4)], 3u, @"");
    XCTAssertEquals([board heightOfSquare:MIXCoreSquareMake(1, 4)], 2u, @"");
    XCTAssertEquals([board heightOfSquare:MIXCoreSquareMake(0, 0)], 1u, @"");
    XCTAssertEquals([board heightOfSquare:MIXCoreSquareMake(3, 3)], 0u, @"nothing set here");
}


- (void)testIsDragLegal {
    
    MIXModelBoard *board = [self boardForTestingMoves];
    
    // legal drags:
    XCTAssertTrueNoThrow([board isDragLegalFrom:MIXCoreSquareMake(4, 4) to:MIXCoreSquareMake(1, 1)], @"");
    XCTAssertTrueNoThrow([board isDragLegalFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(4, 4)], @"");
    XCTAssertTrueNoThrow([board isDragLegalFrom:MIXCoreSquareMake(1, 4) to:MIXCoreSquareMake(1, 1)], @"");
    XCTAssertTrueNoThrow([board isDragLegalFrom:MIXCoreSquareMake(1, 4) to:MIXCoreSquareMake(4, 4)], @"");
    XCTAssertTrueNoThrow([board isDragLegalFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(0, 1)], @"");
    XCTAssertTrueNoThrow([board isDragLegalFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(0, 0)], @"");
    
    // illegal drags because of wrong height:
    XCTAssertFalseNoThrow([board isDragLegalFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(1, 4)], @"");
    XCTAssertFalseNoThrow([board isDragLegalFrom:MIXCoreSquareMake(4, 4) to:MIXCoreSquareMake(1, 4)], @"");
    XCTAssertFalseNoThrow([board isDragLegalFrom:MIXCoreSquareMake(0, 0) to:MIXCoreSquareMake(1, 1)], @"");
    
    // put some pieces between -> legal becomes illegal
    [board setPiece:MIXCoreSquareMake(2, 2)];
    XCTAssertFalseNoThrow([board isDragLegalFrom:MIXCoreSquareMake(4, 4) to:MIXCoreSquareMake(1, 1)], @"");
    XCTAssertFalseNoThrow([board isDragLegalFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(4, 4)], @"");
    
    [board setPiece:MIXCoreSquareMake(1, 3)];
    [board setPiece:MIXCoreSquareMake(3, 4)];
    XCTAssertTrueNoThrow([board isDragLegalFrom:MIXCoreSquareMake(1, 4) to:MIXCoreSquareMake(1, 1)], @"");
    XCTAssertTrueNoThrow([board isDragLegalFrom:MIXCoreSquareMake(1, 4) to:MIXCoreSquareMake(4, 4)], @"");
}


- (void)testIsSettingPossible {
    
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    
    // setting pieces everywhere
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            XCTAssertTrueNoThrow([board isSettingPossible], @"still something free");
            [board setPiece:MIXCoreSquareMake(i, j)];
        }
    }
    XCTAssertFalseNoThrow([board isSettingPossible], @"all 25 squares covered");
    
    // clearing squares as much as possible with the exception of j==0
    // and setting 15 pieces on resulting empty squares
    for (int i = 0; i < 5; i++) {
        for (int j = 2; j < 5; j++) {
            MIXCoreSquare from = MIXCoreSquareMake(i, j-1);
            MIXCoreSquare to = MIXCoreSquareMake(i, j);
            [board dragPiecesFrom:from to:to withNumber:i];
            XCTAssertTrueNoThrow([board isSettingPossible], @"");
            [board setPiece:from];
        }
    }
    // now we have towers of 4 at j==5 and towers of 1 everywhere else
    XCTAssertFalseNoThrow([board isSettingPossible], @"all 25 squares covered");
    
    // everyone should have 5 pieces left
    
    // setting 15 more pieces
    for (int i = 0; i < 5; i++) {

    }
}


@end
