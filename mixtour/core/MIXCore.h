//
//  MIXCore.h
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-18.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//


/**
 This header file is for both Objective-C classes accessing the model and
 the C-part of the project.
 */


#ifndef mixtour_MIXCore_h
#define mixtour_MIXCore_h

#include <stdint.h>
#include <stdbool.h>


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

extern const MIXCoreMove MIXCoreMoveNoMove;

MIXCoreMove MIXCoreMoveMakeDrag(MIXCoreSquare from, MIXCoreSquare to, uint8_t numberOfPieces);
MIXCoreMove MIXCoreMoveMakeSet(MIXCoreSquare to);
bool isMoveDrag(MIXCoreMove move);
bool isMoveANoMove(MIXCoreMove move);
bool MIXCoreMoveEqualToMove(MIXCoreMove move1, MIXCoreMove move2);



#endif
