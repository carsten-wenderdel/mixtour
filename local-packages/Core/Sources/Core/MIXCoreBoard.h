//
//  MIXCoreBoard.h
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-17.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//


#ifndef mixtour_MIXCoreBoard_h
#define mixtour_MIXCoreBoard_h


#include <stdbool.h>
#include <stdint.h>
#include "kvec.h"


#include "MIXCore.h"


#define LENGTH_OF_BOARD 5

/**
 - height is pretty simple - a "4" means 4 pieces
 - colors is a bit more difficult - only the last "height" bits are interesting.
   A "0" means white, a "1" means black. The first bits are undefined.
 */
struct MIXCoreBoard {
    uint8_t height[LENGTH_OF_BOARD][LENGTH_OF_BOARD];
    uint8_t colors[LENGTH_OF_BOARD][LENGTH_OF_BOARD];
    uint8_t whitePieces;
    uint8_t blackPieces;
    uint8_t gameBits;
    MIXCoreMove lastMove;
    MIXCorePlayer turn;
};

typedef struct MIXCoreBoard *MIXCoreBoardRef;


typedef kvec_t(MIXCoreMove) MIXMoveArray;


/**
 Resets the board to the state for a new game
 */
void resetCoreBoard(MIXCoreBoardRef boardRef);

MIXCorePlayer playerOnTurn(MIXCoreBoardRef boardRef);

bool isGameOver(MIXCoreBoardRef boardRef);
bool isGameDraw(MIXCoreBoardRef boardRef);

/**
 returns MIXCorePlayerUndefined when game is not over yet.
 */
MIXCorePlayer winner(MIXCoreBoardRef boardRef);

/**
 Return value not defined for player values not equal to MIXCorePlayerWhite or MIXCorePlayerBlacks
 */
uint8_t numberOfPiecesForPlayer(MIXCoreBoardRef boardRef, MIXCorePlayer player);

bool isSquareEmpty(MIXCoreBoardRef boardRef, MIXCoreSquare square);

uint8_t heightOfSquare(MIXCoreBoardRef boardRef, MIXCoreSquare square);

/**
 The uppermost piece has the position 0.
 When the height is n, the lowermost piece has the position n-1
 */
MIXCorePlayer colorOfSquareAtPosition(MIXCoreBoardRef boardRef, MIXCoreSquare square, uint8_t position);

/**
 Returns MIXCorePlayerUndefined if it's not a winner move
 Does not check whether move is legal or game is already over
 */
MIXCorePlayer potentialWinner(MIXCoreBoardRef boardRef, MIXCoreMove move);

/**
 For dragging: Does check distance and whether pieces are between.
 Does not check whether game is over or move recreates the previous position
 */
bool isMoveLegal(MIXCoreBoardRef boardRef, MIXCoreMove move);

/**
 Does not check whether move is legal.
 */
void makeMove(MIXCoreBoardRef boardRef, MIXCoreMove move);

/**
 Only valid for the player on turn
 */
bool isSettingPossible(MIXCoreBoardRef boardRef);

bool isDraggingPossible(MIXCoreBoardRef boardRef);

/**
 Caller is responsible for releasing memory by calling destroyMoveArray later
 */
void arrayOfLegalMoves(MIXCoreBoardRef boardRef, MIXMoveArray *moveArray);
/// Will return return all moves excluding some moves that would lead to a loss very soon.
void optimizedMoves(MIXCoreBoardRef boardRef, MIXMoveArray *moveArray);

MIXMoveArray newMoveArray();
void destroyMoveArray(MIXMoveArray moveArray);

#pragma mark debug prints
void printBoardDescription(MIXCoreBoardRef boardRef);

#endif
