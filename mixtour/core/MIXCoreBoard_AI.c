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
        MIXCorePlayer returnPlayer = MIXCorePlayerUndefined;   // in case nothing is found
        bool winnerFound = false;
        MIXMoveArray moves = arrayOfLegalMoves(boardRef);
        int arraySize = (int)kv_size(moves);
        if (arraySize == 0) {
            returnPlayer = MIXCorePlayerUndefined;
            winnerFound = true;
        }
        
        MIXCorePlayer turn = playerOnTurn(boardRef);
        for (int i = 0; i < arraySize; i++) {
            MIXCoreMove testMove = kv_A(moves, i);
            if (isMoveDrag(testMove)) { // you cannot win with set moves
                uint8_t heightOfFrom = heightOfSquare(boardRef, testMove.from);
                uint8_t heightOfTo = heightOfSquare(boardRef, testMove.to);
                if (heightOfTo + heightOfFrom >= 5) {
                    MIXCorePlayer colorOfHeighestPiece = colorOfSquareAtPosition(boardRef, testMove.from, 0);
                    if (turn == colorOfHeighestPiece) {
                        returnPlayer = turn;
                        winnerFound = true;
                    }   // TODO: implement the else part, don't follow that path
                }
            }
        }
        
        if (!winnerFound) {
            int randomIndex = rand() % arraySize;
            MIXCoreMove randomMove = kv_A(moves, randomIndex);
            makeMove(boardRef, randomMove);
            if (isGameOver(boardRef)) {
                returnPlayer = winner(boardRef);
                winnerFound = true;
            }
        }
        destroyMoveArray(moves);
        if (winnerFound) {
            return returnPlayer;
        }
    }
    return MIXCorePlayerUndefined;
}


MIXCoreMove bestMoveAfterRandomPlay(MIXCoreBoardRef boardRef) {
    srand(1);

    MIXCoreMove move = MIXCoreMoveNoMove;   // in case nothing is found
    bool bestMoveFound = false;
    MIXMoveArray moves = arrayOfLegalMoves(boardRef);
    unsigned long arraySize = kv_size(moves);
    if (arraySize > 0) {
        int *winsOfBlack = calloc(arraySize, sizeof(int));
        
        struct MIXCoreBoard boardForTrials;
        MIXCoreBoardRef trialRef = &boardForTrials;
        
        // run "numberOfTrials" times through all possible moves
        MIXCorePlayer aIPlayer = playerOnTurn(boardRef);
        for (int trial = 0; trial < numberOfTrials; trial++) {
            for (int i = 0; i < (int)arraySize; i++) {
                boardForTrials = *boardRef;
                MIXCoreMove trialMove = kv_A(moves, i);
                makeMove(trialRef, trialMove);
                MIXCorePlayer winnerOfTrial;
                if (isGameOver(trialRef) && (winner(boardRef) == aIPlayer)) {
                    move = trialMove;
                    bestMoveFound = true;
                    break;
                } else {
                    winnerOfTrial = winnerAfterRandomPlay(trialRef);
                    winsOfBlack[i] += winnerOfTrial;
                }
            }
            if (bestMoveFound) {
                break;
            }
        }
        
        if (!bestMoveFound) {
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
        }
        
        free(winsOfBlack);
    }
    destroyMoveArray(moves);
    return move;
}

MIXCoreMove bestMove(MIXCoreBoardRef boardRef) {
    return bestMoveAfterRandomPlay(boardRef);
}



