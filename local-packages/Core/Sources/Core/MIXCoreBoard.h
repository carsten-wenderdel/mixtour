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
#include "CoreArray.h"

#define LENGTH_OF_BOARD 5

typedef enum {
    MIXCorePlayerWhite = 0,
    MIXCorePlayerBlack = 1,
    MIXCorePlayerUndefined = -1
} MIXCorePlayer;


typedef struct {
    uint8_t column;
    uint8_t line;
} MIXCoreSquare;

bool MIXCoreSquareIsEqualToSquare(MIXCoreSquare square1, MIXCoreSquare square2);


typedef struct {
    MIXCoreSquare from;
    MIXCoreSquare to;
    uint8_t numberOfPieces;
} MIXCoreMove;

/// For Monte Carlo Tree Search and other algorithms the list of legal moves is the the crucial function where CPU spends most time.
/// This could be sped up with bitboards. A 32 bit variable could contain bits for all 25 fields. Maybe 64 bit variables are more efficient
/// Bitshift operations and logical AND / OR could be used to identify possible moves.
/// One 32 bit variable could contain bits for:
/// - Exactly 4 pieces high (etc.)
/// - Exactly 3 pieces high (etc.)
/// - Empty fields
/// - Upper most color is white
/// - Second upper most color is white (etc.)

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

extern const MIXCoreMove MIXCoreMoveNoMove;

MIXCoreMove MIXCoreMoveMakeDrag(MIXCoreSquare from, MIXCoreSquare to, uint8_t numberOfPieces);
MIXCoreMove MIXCoreMoveMakeSet(MIXCoreSquare to);
bool isMoveDrag(MIXCoreMove move);
bool isMoveSet(MIXCoreMove move);
bool isMoveANoMove(MIXCoreMove move);
bool MIXCoreMoveEqualToMove(MIXCoreMove move1, MIXCoreMove move2);

/**
 Only works for drag moves
 */
bool isMoveRevertOfMove(MIXCoreMove move1, MIXCoreMove move2);

typedef core_array_type(MIXCoreMove) MIXMoveArray;

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
 Does not return all legal moves, slightly optimized.
 Caller is responsible for releasing memory by calling destroyMoveArray later
 */
void sensibleMoves(MIXCoreBoardRef boardRef, MIXMoveArray *moveArray);

MIXMoveArray newMoveArray();
void destroyMoveArray(MIXMoveArray moveArray);

#pragma mark debug prints
void printBoardDescription(MIXCoreBoardRef boardRef);

#endif
