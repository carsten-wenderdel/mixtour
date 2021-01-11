//
//  MIXCoreBoard_AI.h
//  mixtour
//
//  Created by Wenderdel, Carsten on 04/05/16.
//  Copyright © 2016 Carsten Wenderdel. All rights reserved.
//

#ifndef MIXCoreBoard_AI_h
#define MIXCoreBoard_AI_h

#include "MIXCore.h"

#include "MIXCoreBoard.h"

typedef struct {
    int numberOfMoves;
    MIXCorePlayer winner;
} MIXCorePlayResult;

MIXCoreMove bestMove(MIXCoreBoardRef boardRef, int numberOfTrials);

/** Make sure that no integer overflow happens */
bool isNumberOfTrialsSmallEnough(int numberOfTrials);

#endif /* MIXCoreBoard_AI_h */

