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

#include "MIXCore.h"



/**
 - height is pretty simple - a "4" means 4 pieces
 - colors is a bit more difficult - only the last "height" bits are interesting.
   A "0" means white, a "1" means black. The first bits are undefined.
 */
struct MIXCoreBoard {
    uint8_t height[5][5];
    uint8_t colors[5][5];
    uint8_t whitePieces;
    uint8_t blackPieces;
    MIXCorePlayer turn;
};

typedef struct MIXCoreBoard *MIXCoreBoardRef;



/**
 Resets the board to the state for a new game
 */
void resetCoreBoard(MIXCoreBoardRef boardRef);

MIXCorePlayer playerOnTurn(MIXCoreBoardRef boardRef);

uint8_t numberOfPiecesForPlayer(MIXCoreBoardRef boardRef, MIXCorePlayer player);

bool isSquareEmpty(MIXCoreBoardRef boardRef, MIXCoreSquare square);

uint8_t heightOfSquare(MIXCoreBoardRef boardRef, MIXCoreSquare square);

/**
 The uppermost piece has the position 0.
 When the height is n, the lowermost piece has the position n-1
 */
MIXCorePlayer colorOfSquareAtPosition(MIXCoreBoardRef boardRef, MIXCoreSquare square, uint_fast8_t position);

/**
 Does not check whether setting is legal.
 */
void setPiece(MIXCoreBoardRef boardRef, MIXCoreSquare square);

bool isDistanceRight(MIXCoreBoardRef boardRef, MIXCoreSquare from, MIXCoreSquare to);

/**
 Does check distance and whether pieces are between.
 Does not check whether game is over or move recreates the previous position
 */
bool isDragLegal(MIXCoreBoardRef boardRef, MIXCoreSquare from, MIXCoreSquare to);

/**
 Does not check whether setting is legal.
 */
void dragPieces(MIXCoreBoardRef boardRef, MIXCoreSquare from, MIXCoreSquare to, uint8_t numberODraggedPieces);


#endif
