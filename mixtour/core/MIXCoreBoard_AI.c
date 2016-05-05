//
//  MIXCoreBoard_AI.c
//  mixtour
//
//  Created by Wenderdel, Carsten on 04/05/16.
//  Copyright © 2016 Carsten Wenderdel. All rights reserved.
//

#include "MIXCoreBoard_AI.h"

static const int maximumNumberOfMoves = 400;
static const int numberOfTrials = 100;



MIXCoreMove firstMove(MIXCoreBoardRef boardRef) {
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


MIXCorePlayer winnerAfterRandomPlay(MIXCoreBoardRef boardRef) {
    for (int m = 0; m < maximumNumberOfMoves; m++) {
        MIXMoveArray moves = arrayOfLegalMoves(boardRef);
        int arraySize = (int)kv_size(moves);
        if (arraySize == 0) {
            return MIXCorePlayerUndefined;
        }
        for (int i = 0; i < arraySize; i++) {
            MIXCoreMove testMove = kv_A(moves, i);
            if (isMoveDrag(testMove)) {
                uint8_t heightOfFrom = heightOfSquare(boardRef, testMove.from);
                uint8_t heightOfTo = heightOfSquare(boardRef, testMove.to);
                if (heightOfTo + heightOfFrom >= 5) {
                    MIXCorePlayer colorOfHeighestPiece = colorOfSquareAtPosition(boardRef, testMove.from, 0);
                    return colorOfHeighestPiece;
                }
            }
        }
        int randomIndex = rand() % arraySize;
        MIXCoreMove randomMove = kv_A(moves, randomIndex);
        makeMove(boardRef, randomMove);
        destroyMoveArray(moves);
    }
    return MIXCorePlayerUndefined;
}


MIXCoreMove bestMoveAfterRandomPlay(MIXCoreBoardRef boardRef) {
    srand(1);

    MIXCoreMove move;
    MIXMoveArray moves = arrayOfLegalMoves(boardRef);
    unsigned long arraySize = kv_size(moves);
    if (arraySize == 0) {
        move = MIXCoreMoveNoMove;
    } else {
        int *winsOfBlack = calloc(arraySize, sizeof(int));
        
        struct MIXCoreBoard boardForTrials;
        MIXCoreBoardRef trialRef = &boardForTrials;
        
        // run "numberOfTrials" times through all possible moves
        for (int trial = 0; trial < numberOfTrials; trial++) {
            for (int i = 0; i < (int)arraySize; i++) {
                boardForTrials = *boardRef;
                makeMove(trialRef, kv_A(moves, i));
                MIXCorePlayer winner = winnerAfterRandomPlay(trialRef);
                winsOfBlack[i] += winner;
            }
        }
        
        // find the move with the most wins for black
        int indexOfBestMove = 0;
        
        if (playerOnTurn(boardRef) == MIXCorePlayerWhite) {
            // find min
            for (int i = 1; i < (int)arraySize; i++) {
                if (winsOfBlack[i] < winsOfBlack[indexOfBestMove]) {
                    indexOfBestMove = i;
                }
            }
        } else {
            // find max
            for (int i = 1; i < (int)arraySize; i++) {
                if (winsOfBlack[i] > winsOfBlack[indexOfBestMove]) {
                    indexOfBestMove = i;
                }
            }
        }
        move = kv_A(moves, indexOfBestMove);

        free(winsOfBlack);
    }
    destroyMoveArray(moves);
    return move;
}

MIXCoreMove bestMove(MIXCoreBoardRef boardRef) {
    return bestMoveAfterRandomPlay(boardRef);
}



