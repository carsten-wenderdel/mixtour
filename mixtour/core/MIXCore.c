//
//  MIXCore.c
//  mixtour
//
//  Created by Carsten Wenderdel on 2015-04-02.
//  Copyright (c) 2015 Carsten Wenderdel. All rights reserved.
//

#include "MIXCore.h"

static const uint8_t kMoveSetIndicator = 6;
static const uint8_t kMoveNoMoveIndicator = 7;

const MIXCoreMove MIXCoreMoveNoMove = {{kMoveNoMoveIndicator, 0u}, {0u, 0u}, 0u};

bool MIXCoreSquareIsEqualToSquare(MIXCoreSquare square1, MIXCoreSquare square2) {
    return square1.column == square2.column && square1.line == square2.line;
}

MIXCoreMove MIXCoreMoveMakeDrag(MIXCoreSquare from, MIXCoreSquare to, uint8_t numberOfPieces) {
    MIXCoreMove move;
    move.from = from;
    move.to = to;
    move.numberOfPieces = numberOfPieces;
    return move;
}

MIXCoreMove MIXCoreMoveMakeSet(MIXCoreSquare to) {
    MIXCoreMove move;
    move.from.column = kMoveSetIndicator;
    move.to = to;
    return move;
}

bool isMoveDrag(MIXCoreMove move) {
    return move.from.column != kMoveSetIndicator;
}

bool isMoveANoMove(MIXCoreMove move)  {
    return move.from.column == kMoveNoMoveIndicator;
}

bool MIXCoreMoveEqualToMove(MIXCoreMove move1, MIXCoreMove move2) {
    if (isMoveDrag(move1)) {
        return MIXCoreSquareIsEqualToSquare(move1.from, move2.from) &&
                MIXCoreSquareIsEqualToSquare(move2.to, move2.to) &&
                move1.numberOfPieces == move2.numberOfPieces;
    } else {
        return MIXCoreSquareIsEqualToSquare(move1.to, move2.to);
    }
}

