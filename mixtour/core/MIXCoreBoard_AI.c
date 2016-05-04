//
//  MIXCoreBoard_AI.c
//  mixtour
//
//  Created by Wenderdel, Carsten on 04/05/16.
//  Copyright © 2016 Carsten Wenderdel. All rights reserved.
//

#include "MIXCoreBoard_AI.h"


MIXCoreMove bestMove(MIXCoreBoardRef boardRef) {
    MIXMoveArray moves = arrayOfLegalMoves(boardRef);
    MIXCoreMove move;
    if (kv_size(moves)) {
        move = kv_A(moves, 0);
    } else {
        move = MIXCoreMoveNoMove;
    }
    destroyMoveArray(moves);
    return move;
}

