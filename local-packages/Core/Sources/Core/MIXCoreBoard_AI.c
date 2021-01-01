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


MIXCorePlayResult winnerAfterRandomPlay(MIXCoreBoardRef boardRef) {
    for (int m = 0; m < maximumNumberOfMoves; m++) {
        if (isGameOver(boardRef)) {
            MIXCorePlayResult result;
            result.winner = winner(boardRef);
            result.numberOfMoves = m;
            return result;
        }
        
        MIXCorePlayer returnPlayer = MIXCorePlayerUndefined;   // in case nothing is found
        bool winnerFound = false;
        MIXMoveArray moves = arrayOfLegalMoves(boardRef);
        int arraySize = (int)kv_size(moves);
        if (arraySize == 0) {
            returnPlayer = MIXCorePlayerUndefined;
            winnerFound = true;
        } else {
            MIXCorePlayer turn = playerOnTurn(boardRef);
            for (int i = 0; i < arraySize; i++) {
                MIXCoreMove testMove = kv_A(moves, i);
                if (turn == potentialWinner(boardRef, testMove)) {
                    returnPlayer = turn;
                    winnerFound = true;
                    break;
                }
            }
        }
        
        if (!winnerFound) {
            int randomIndex = 0;
            // suppress Clang static analyzer warning
#ifndef __clang_analyzer__
            randomIndex = rand() % arraySize;
#endif
            MIXCoreMove randomMove = kv_A(moves, randomIndex);
            makeMove(boardRef, randomMove);
        }
        destroyMoveArray(moves);
        if (winnerFound) {
            MIXCorePlayResult result;
            result.winner = returnPlayer;
            result.numberOfMoves = m + 1;
            return result;
        }
    }
    MIXCorePlayResult result;
    result.winner = MIXCorePlayerUndefined;
    result.numberOfMoves = maximumNumberOfMoves + 1;
    return result;
}


MIXCoreMove bestMoveAfterRandomPlay(MIXCoreBoardRef boardRef) {
    srand(1);

    MIXCoreMove move = MIXCoreMoveNoMove;   // in case nothing is found
    bool bestMoveFound = false;
    MIXMoveArray moves = arrayOfLegalMoves(boardRef);
    unsigned long arraySize = kv_size(moves);
    if (arraySize > 0) {
        // both arrays - increased for a win of black, decreased for a win of white
        int *numberOfWins = calloc(arraySize, sizeof(int));
        int *lenghtsOfGames = calloc(arraySize, sizeof(int));
        
        // run "numberOfTrials" times through all possible moves
        MIXCorePlayer aIPlayer = playerOnTurn(boardRef);
        for (int i = 0; i < (int)arraySize; i++) {
            struct MIXCoreBoard boardForTrials = *boardRef;
            MIXCoreBoardRef trialRef = &boardForTrials;
            MIXCoreMove trialMove = kv_A(moves, i);
            makeMove(trialRef, trialMove);
            
            if (isGameOver(trialRef) && (winner(trialRef) == aIPlayer)) {
                move = trialMove;
                bestMoveFound = true;
                break;
            } else {
                for (int trial = 0; trial < numberOfTrials; trial++) {
                    struct MIXCoreBoard randomPlayBoard = boardForTrials;
                    MIXCorePlayResult result = winnerAfterRandomPlay(&randomPlayBoard);
                    switch (result.winner) {
                        case MIXCorePlayerBlack:
                            lenghtsOfGames[i] += result.numberOfMoves;
                            numberOfWins[i] += 1;
                            break;
                        case MIXCorePlayerWhite:
                            lenghtsOfGames[i] -= result.numberOfMoves;
                            numberOfWins[i] -= 1;
                        default:
                            // Unknown player - don't increment
                        break;
                    }
                }
            }
        }
        
        if (!bestMoveFound) {
            // find the move with the most wins for black
            // If for example there are only wins for the opponent, we want to pick the move where the number of following moves is biggest.
            int indexOfBestMove = 0;
            
            if (playerOnTurn(boardRef) == MIXCorePlayerWhite) {
                // find min
                for (int i = 1; i < (int)arraySize; i++) {
                    if (numberOfWins[i] < numberOfWins[indexOfBestMove]) {
                        indexOfBestMove = i;
                    } else if (numberOfWins[i] == numberOfWins[indexOfBestMove && lenghtsOfGames[i] > lenghtsOfGames[indexOfBestMove]]) {
                        indexOfBestMove = i; // different line for debugging purposes. Compiler will optimize anyway.
                    }
                }
            } else {
                // find max
                for (int i = 1; i < (int)arraySize; i++) {
                    if (numberOfWins[i] > numberOfWins[indexOfBestMove]) {
                        indexOfBestMove = i;
                    } else if (numberOfWins[i] == numberOfWins[indexOfBestMove] && lenghtsOfGames[i] < lenghtsOfGames[indexOfBestMove]) {
                        indexOfBestMove = i;
                    }
                }
            }
            move = kv_A(moves, indexOfBestMove);
        }
        
        free(numberOfWins);
    }
    destroyMoveArray(moves);
    return move;
}

MIXCoreMove bestMove(MIXCoreBoardRef boardRef) {
    return bestMoveAfterRandomPlay(boardRef);
}



