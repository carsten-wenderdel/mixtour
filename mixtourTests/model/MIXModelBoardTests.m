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

    XCTAssertEqual([modelBoard playerOnTurn], MIXCorePlayerWhite, @"White should start game");
    XCTAssertEqual([modelBoard numberOfPiecesForPlayer:MIXCorePlayerWhite], 20u, @"25 pieces at the start");
    XCTAssertEqual([modelBoard numberOfPiecesForPlayer:MIXCorePlayerBlack], 20u, @"25 pieces at the start");
    
    for (uint8_t i = 0; i < 5; i++) {
        for (uint8_t j = 0; j < 5; j++) {
            MIXCoreSquare square = MIXCoreSquareMake(i, j);
            XCTAssertTrue([modelBoard isSquareEmpty:square], @"at the the start everything is empty");
            XCTAssertEqual([modelBoard heightOfSquare:MIXCoreSquareMake(i, j)], 0u, @"at the start everything should be empty");
        }
    }
}


- (void)testGameOver {
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    XCTAssertFalse([board isGameOver], @"");
    
    [board setPiece:MIXCoreSquareMake(0, 0)];
    for (int i = 1; i < 5; i++) {
        XCTAssertFalse([board isGameOver], @"");
        MIXCoreSquare oldSquare = MIXCoreSquareMake(0, i - 1);
        MIXCoreSquare newSquare = MIXCoreSquareMake(0, i);
        [board setPiece:newSquare];
        [board dragPiecesFrom:oldSquare to:newSquare withNumber:i];
    }
    XCTAssertTrue([board isGameOver], @"");
}


- (void)testWinner {
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    XCTAssertEqual([board winner], MIXCorePlayerUndefined, @"");
    
    [board setPiece:MIXCoreSquareMake(0, 0)];
    for (int i = 1; i < 5; i++) {
        XCTAssertEqual([board winner], MIXCorePlayerUndefined, @"");
        MIXCoreSquare oldSquare = MIXCoreSquareMake(0, i - 1);
        MIXCoreSquare newSquare = MIXCoreSquareMake(0, i);
        [board setPiece:newSquare];
        [board dragPiecesFrom:oldSquare to:newSquare withNumber:i];
    }
    
    XCTAssertEqual([board winner], MIXCorePlayerWhite, @"");
    
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
    
    XCTAssertEqual([board winner], MIXCorePlayerBlack, @"");
}


- (void)testPlayerOnTurn {
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerWhite, @"");
    
    [board setPiece:MIXCoreSquareMake(1, 1)];
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerBlack, @"");
    
    [board setPiece:MIXCoreSquareMake(1, 2)];
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerWhite, @"");
    
    [board setPiece:MIXCoreSquareMake(2, 2)];
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerBlack, @"");
    
    [board dragPiecesFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(1, 2) withNumber:1];
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerWhite, @"");
    
    [board dragPiecesFrom:MIXCoreSquareMake(2, 2) to:MIXCoreSquareMake(1, 2) withNumber:1];
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerWhite, @"illegal move, turn stays");
    
    [board dragPiecesFrom:MIXCoreSquareMake(1, 2) to:MIXCoreSquareMake(2, 2) withNumber:1];
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerBlack, @"");
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
    
    XCTAssertEqual([board numberOfPiecesForPlayer:MIXCorePlayerWhite], 18u, @"two pieces set");
    XCTAssertEqual([board numberOfPiecesForPlayer:MIXCorePlayerBlack], 19u,
                    @"only one piece set, one move attempt was illegal");
    
    XCTAssertEqual([board heightOfSquare:square2], 1u, @"one piece set -> height 1");
    XCTAssertEqual([board heightOfSquare:square1], 1u, @"you can only set once -> height 1");
    XCTAssertEqual([board heightOfSquare:MIXCoreSquareMake(0, 0)], 0u, @"nothing set here");
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
    
    XCTAssertEqual([board colorOfSquare:square0 atPosition:0u], MIXCorePlayerWhite, @"");
    XCTAssertEqual([board colorOfSquare:square1 atPosition:0u], MIXCorePlayerBlack, @"");
    XCTAssertEqual([board colorOfSquare:square2 atPosition:0u], MIXCorePlayerWhite, @"");
    XCTAssertEqual([board colorOfSquare:square3 atPosition:0u], MIXCorePlayerBlack, @"");
    XCTAssertEqual([board colorOfSquare:square4 atPosition:0u], MIXCorePlayerWhite, @"");
    
    [board dragPiecesFrom:square1 to:square0 withNumber:1u];
    [board dragPiecesFrom:square4 to:square3 withNumber:1u];
    [board dragPiecesFrom:square3 to:square2 withNumber:2u];
    [board dragPiecesFrom:square2 to:square0 withNumber:2u]; // not all!
    
    XCTAssertEqual([board colorOfSquare:square0 atPosition:3u], MIXCorePlayerWhite, @"here from the beginning");
    XCTAssertEqual([board colorOfSquare:square0 atPosition:2u], MIXCorePlayerBlack, @"originally at square1");
    XCTAssertEqual([board colorOfSquare:square0 atPosition:1u], MIXCorePlayerBlack, @"originally at square3");
    XCTAssertEqual([board colorOfSquare:square0 atPosition:0u], MIXCorePlayerWhite, @"originally at square4");
    XCTAssertEqual([board colorOfSquare:square2 atPosition:0u], MIXCorePlayerWhite, @"here from the beginning");
    
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
    
    XCTAssertEqual([board heightOfSquare:MIXCoreSquareMake(1, 1)], 3u, @"");
    XCTAssertEqual([board heightOfSquare:MIXCoreSquareMake(4, 4)], 3u, @"");
    XCTAssertEqual([board heightOfSquare:MIXCoreSquareMake(1, 4)], 2u, @"");
    XCTAssertEqual([board heightOfSquare:MIXCoreSquareMake(0, 0)], 1u, @"");
    XCTAssertEqual([board heightOfSquare:MIXCoreSquareMake(3, 3)], 0u, @"nothing set here");
}


- (void)testIsDragLegal {
    
    MIXModelBoard *board = [self boardForTestingMoves];
    
    // legal drags:
    XCTAssertTrue([board isDragLegalFrom:MIXCoreSquareMake(4, 4) to:MIXCoreSquareMake(1, 1)], @"");
    XCTAssertTrue([board isDragLegalFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(4, 4)], @"");
    XCTAssertTrue([board isDragLegalFrom:MIXCoreSquareMake(1, 4) to:MIXCoreSquareMake(1, 1)], @"");
    XCTAssertTrue([board isDragLegalFrom:MIXCoreSquareMake(1, 4) to:MIXCoreSquareMake(4, 4)], @"");
    XCTAssertTrue([board isDragLegalFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(0, 1)], @"");
    XCTAssertTrue([board isDragLegalFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(0, 0)], @"");
    
    // illegal drags because of wrong height:
    XCTAssertFalse([board isDragLegalFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(1, 4)], @"");
    XCTAssertFalse([board isDragLegalFrom:MIXCoreSquareMake(4, 4) to:MIXCoreSquareMake(1, 4)], @"");
    XCTAssertFalse([board isDragLegalFrom:MIXCoreSquareMake(0, 0) to:MIXCoreSquareMake(1, 1)], @"");
    
    // put some pieces between -> legal becomes illegal
    [board setPiece:MIXCoreSquareMake(2, 2)];
    XCTAssertFalse([board isDragLegalFrom:MIXCoreSquareMake(4, 4) to:MIXCoreSquareMake(1, 1)], @"");
    XCTAssertFalse([board isDragLegalFrom:MIXCoreSquareMake(1, 1) to:MIXCoreSquareMake(4, 4)], @"");
    
    [board setPiece:MIXCoreSquareMake(1, 3)];
    [board setPiece:MIXCoreSquareMake(3, 4)];
    XCTAssertTrue([board isDragLegalFrom:MIXCoreSquareMake(1, 4) to:MIXCoreSquareMake(1, 1)], @"");
    XCTAssertTrue([board isDragLegalFrom:MIXCoreSquareMake(1, 4) to:MIXCoreSquareMake(4, 4)], @"");
}


- (void)testIsSettingPossible {
    
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    
    // setting pieces everywhere
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            XCTAssertTrue([board isSettingPossible], @"still something free");
            [board setPiece:MIXCoreSquareMake(i, j)];
        }
    }
    XCTAssertFalse([board isSettingPossible], @"all 25 squares covered");
    
    // clearing (15) squares as much as possible with the exception of j==0
    for (int i = 0; i < 5; i++) {
        for (int j = 1; j < 4; j++) {
            MIXCoreSquare from = MIXCoreSquareMake(i, j);
            MIXCoreSquare to = MIXCoreSquareMake(i, j+1);
            [board dragPiecesFrom:from to:to withNumber:j];
            XCTAssertTrue([board isSettingPossible], @"");
        }
    }
    
    XCTAssertEqual([board numberOfPiecesForPlayer:MIXCorePlayerWhite], 7u, @"");
    XCTAssertEqual([board numberOfPiecesForPlayer:MIXCorePlayerBlack], 8u, @"");
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerWhite, @"");
    
    // setting 14 pieces on cleared squares
    for (int i = 0; i < 5; i++) {
        for (int j = 1; j < 4; j++) {
            if (i != 4 || j != 3) {
                XCTAssertTrue([board isSettingPossible], @"");
                MIXCoreSquare square = MIXCoreSquareMake(i, j);
                XCTAssertTrue([board isSquareEmpty:square]);
                [board setPiece:square];
            }
        }
    }
    
    XCTAssertEqual([board numberOfPiecesForPlayer:MIXCorePlayerWhite], 0u, @"");
    XCTAssertEqual([board numberOfPiecesForPlayer:MIXCorePlayerBlack], 1u, @"");
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerWhite, @"");
    
    MIXCoreSquare emptySquare = MIXCoreSquareMake(4, 3);
    XCTAssertTrue([board isSquareEmpty:emptySquare]);
    XCTAssertFalse([board isSettingPossible], @"no pieces left for white");
    
    [board dragPiecesFrom:MIXCoreSquareMake(1, 4) to:MIXCoreSquareMake(1, 3) withNumber:3];
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerBlack, @"");
    XCTAssertTrue([board isSettingPossible], @"");
    [board setPiece:emptySquare];
    
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerWhite, @"");
    XCTAssertFalse([board isSettingPossible], @"");
    [board dragPiecesFrom:MIXCoreSquareMake(1, 3) to:MIXCoreSquareMake(1, 4) withNumber:3];
    
    XCTAssertEqual([board playerOnTurn], MIXCorePlayerBlack, @"");
    XCTAssertFalse([board isSettingPossible], @"no pieces left for black");
}



@end
