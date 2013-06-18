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



#endif
