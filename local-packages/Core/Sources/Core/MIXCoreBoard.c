//
//  MIXCoreBoard.c
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-17.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//


#include "MIXCoreBoard.h"

#include <stdio.h>
#include <stdlib.h>
#include "MIXCoreHelper.h"


// Lot's of stuff going on in a single file. But spreading it to multiple files
// would mean that inlining isn't possible. And that would hurt performance.


#define MIX_CORE_NUMBER_OF_PIECES_OF_ONE_COLOR 20
#define MIX_CORE_NUMBER_OF_PIECES_TO_WIN 5
#define MIX_BIGGEST_BOARD_INDEX 4


/// Various bits containing information about the game state.
enum MIXCoreGameBits {
    MIXCoreGameBitsWinner = 1,  // Only defined if game is over. 0 means White has won, 1 means Black has won
    MIXCoreGameBitsGameOver = 1 << 1,   // 1 if game over, 0 if game is running
    MIXCoreGameBitsGameDraw = 1 << 2,   // Only defined if game is over. 1 means draw, 0 means there is a winner.
    MIXCoreGameBitsMovePass = 1 << 3    // 1 if last move was a pass, 0 at game start and when last move was set or draw.
};
typedef enum MIXCoreGameBits MIXCoreGameBits;

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
    return !isMoveSet(move) && !isMoveANoMove(move);
}

bool isMoveSet(MIXCoreMove move) {
    return move.from.column == kMoveSetIndicator;
}

bool isMoveANoMove(MIXCoreMove move)  {
    return move.from.column == kMoveNoMoveIndicator;
}

bool MIXCoreMoveEqualToMove(MIXCoreMove move1, MIXCoreMove move2) {

    if (isMoveANoMove(move1)) {
        return isMoveANoMove(move2);
    } else if (isMoveSet(move1)){
        return isMoveSet(move2)
            && MIXCoreSquareIsEqualToSquare(move1.to, move2.to);
    } else {
        return MIXCoreSquareIsEqualToSquare(move1.from, move2.from)
            && MIXCoreSquareIsEqualToSquare(move1.to, move2.to)
            && move1.numberOfPieces == move2.numberOfPieces;
    }
}

bool isMoveRevertOfMove(MIXCoreMove newMove, MIXCoreMove oldMove) {
    return MIXCoreSquareIsEqualToSquare(oldMove.from, newMove.to)
        && MIXCoreSquareIsEqualToSquare(oldMove.to, newMove.from)
        && oldMove.numberOfPieces == newMove.numberOfPieces;
}


void dragPieces(MIXCoreBoardRef boardRef, MIXCoreSquare from, MIXCoreSquare to, uint8_t numberOfDraggedPieces);

    

void resetCoreBoard(MIXCoreBoardRef boardRef) {
    
    *boardRef = (struct MIXCoreBoard){0};
    boardRef->turn = MIXCorePlayerWhite;
    boardRef->whitePieces = boardRef->blackPieces = MIX_CORE_NUMBER_OF_PIECES_OF_ONE_COLOR;
}


MIXCorePlayer playerOnTurn(MIXCoreBoardRef boardRef) {
    
    return boardRef->turn;
}


bool isGameOver(MIXCoreBoardRef boardRef) {
    return (boardRef->gameBits & MIXCoreGameBitsGameOver) != 0;
}

bool isGameDraw(MIXCoreBoardRef boardRef) {
    return isGameOver(boardRef) && (boardRef->gameBits & MIXCoreGameBitsGameDraw) != 0;
}


MIXCorePlayer winner(MIXCoreBoardRef boardRef) {
    if (isGameOver(boardRef)) {
        if ((boardRef->gameBits & MIXCoreGameBitsGameDraw) != 0) {
            return MIXCorePlayerUndefined;
        } else {
            return boardRef->gameBits & MIXCoreGameBitsWinner;
        }
    } else {
        return MIXCorePlayerUndefined;
    }
}


uint8_t numberOfPiecesForPlayer(MIXCoreBoardRef boardRef, MIXCorePlayer player) {
    
    if (MIXCorePlayerWhite == player) {
        return boardRef->whitePieces;
    } else {
        return boardRef->blackPieces;
    }
}


bool isSquareEmpty(MIXCoreBoardRef boardRef, MIXCoreSquare square) {
    
   return (0 == boardRef->height[square.column][square.line]);
}


uint8_t heightOfSquare(MIXCoreBoardRef boardRef, MIXCoreSquare square) {
    
    return boardRef->height[square.column][square.line];
}


MIXCorePlayer colorOfSquareAtPosition(MIXCoreBoardRef boardRef, MIXCoreSquare square, uint8_t position) {
    
    // All colors at that position encoded in one integer variable:
    uint8_t color = boardRef->colors[square.column][square.line];
    // Shift colors to the right so that the important bit is at the very right:
    color >>= position;
    // Set all other bits which are not at the very right to zero:
    color &= 1;
    // return value will be either 0 or 1
    return (MIXCorePlayer)color;
}


/**
 Does not check whether setting is legal. Don't call directly, lastMove not saved.
 */
void setPiece(MIXCoreBoardRef boardRef, MIXCoreSquare square) {
    
    boardRef->height[square.column][square.line] = 1;
    
    if (MIXCorePlayerWhite == boardRef->turn) {
        boardRef->whitePieces--;
        boardRef->turn = MIXCorePlayerBlack;
    } else {
        boardRef->blackPieces--;
        boardRef->turn = MIXCorePlayerWhite;
        boardRef->colors[square.column][square.line] = 1;
    }
}

/**
 Does not check whether setting is legal. Don't call directly, lastMove not saved.
 */
void makePass(MIXCoreBoardRef boardRef) {
    boardRef->gameBits |= MIXCoreGameBitsMovePass;
    boardRef->turn ^= MIXCorePlayerBlack;
    if (isMoveANoMove(boardRef->lastMove)) {
        // 2 passes in a row -> game over!
        boardRef->gameBits |= MIXCoreGameBitsGameOver;
        // It's a draw
        boardRef->gameBits |= MIXCoreGameBitsGameDraw;
    }
}

bool isDistanceRight(MIXCoreBoardRef boardRef, MIXCoreSquare from, MIXCoreSquare to) {

    if (MIXCoreSquareIsEqualToSquare(from, to)) {
        return false;
    }
    uint8_t height = boardRef->height[to.column][to.line];
    int8_t columnDiff = abs(from.column - to.column);
    int8_t lineDiff = abs(from.line - to.line);

    return (columnDiff == 0 || columnDiff == height) && (lineDiff == 0 || lineDiff == height);
}


/**
 square1 and square2 need to be on one line (horizontally, vertically or cross). Use only internally, columnSignum and lineSignum have to be correct.
 */
bool isSomethingBetweenSquares(MIXCoreBoardRef boardRef, MIXCoreSquare square1, MIXCoreSquare square2, int8_t columnSignum, int8_t lineSignum) {
    MIXCoreSquare betweenSquare = {(uint8_t)(square1.column + columnSignum), (uint8_t)(square1.line + lineSignum)};
    while (!MIXCoreSquareIsEqualToSquare(betweenSquare, square2)) {
        if (!isSquareEmpty(boardRef, betweenSquare)) {
            return true;
        }
        betweenSquare = (MIXCoreSquare){(uint8_t)(betweenSquare.column + columnSignum), (uint8_t)(betweenSquare.line + lineSignum)};
    }
    return false;
}


bool isAPieceBetween(MIXCoreBoardRef boardRef, MIXCoreSquare from, MIXCoreSquare to) {

    int8_t columnSignum = signum((int8_t)to.column - from.column);
    int8_t lineSignum = signum((int8_t)to.line - from.line);
    return isSomethingBetweenSquares(boardRef, from, to, columnSignum, lineSignum);
}


bool isMoveLegal(MIXCoreBoardRef boardRef, MIXCoreMove move) {
    
    if (isGameOver(boardRef)) {
        return false;
    }

    if (isMoveANoMove(move)) {
        // player can't pass if other move is possible
        return !(isSettingPossible(boardRef) || isDraggingPossible(boardRef));
    } else if (isMoveSet(move)) {
        if (! isSquareEmpty(boardRef, move.to)) {
            return false;
        }

        MIXCorePlayer player = playerOnTurn(boardRef);
        return numberOfPiecesForPlayer(boardRef, player) > 0;
    } else { // Move is drag

        if (isMoveRevertOfMove(move, boardRef->lastMove)) {
            return false;
        }

        if (move.numberOfPieces == 0) {
            return false;
        }
        
        MIXCoreSquare from = move.from;
        MIXCoreSquare to = move.to;
        
        if (!isDistanceRight(boardRef, from, to)) {
            return false;
        }
        
        if (isAPieceBetween(boardRef, from, to)) {
            return false;
        }
        
        return true; // nothing found, looks good
    }
}

MIXCorePlayer potentialWinner(MIXCoreBoardRef boardRef, MIXCoreMove move) {
    if (isMoveDrag(move)) {
        uint8_t fromHeight = heightOfSquare(boardRef, move.from);
        uint8_t toHeight = heightOfSquare(boardRef, move.to);
        if (fromHeight + toHeight >= MIX_CORE_NUMBER_OF_PIECES_TO_WIN) {
            return colorOfSquareAtPosition(boardRef, move.from, 0);
        }
    }
    return MIXCorePlayerUndefined;
}

void makeMove(MIXCoreBoardRef boardRef, MIXCoreMove move) {
    if (isMoveSet(move)) {
        setPiece(boardRef, move.to);
    } else if (isMoveANoMove(move)) {
        makePass(boardRef);
    } else { // Drag
        dragPieces(boardRef, move.from, move.to, move.numberOfPieces);
    }
    boardRef->lastMove = move;
}


/**
 Does not check whether move is legal. Don't call directly, lastMove not saved.
 */
void dragPieces(MIXCoreBoardRef boardRef, MIXCoreSquare from, MIXCoreSquare to, uint8_t numberOfDraggedPieces) {

    boardRef->height[from.column][from.line] -= numberOfDraggedPieces;
    boardRef->height[to.column][to.line] += numberOfDraggedPieces;
    
    // Make a mask that has zeros for the last "numberOfDraggedPieces" bits, ones everywhere else
    uint8_t mask = (uint8_t)(UINT8_MAX << numberOfDraggedPieces);
    // now the last bits are set, the others not.
    mask = ~mask;
    // Remove all bits of those positions which are not removed.
    // In the last bits we then have the important information, 0 for white, 1 for black
    uint8_t colorsToDrag = (boardRef->colors[from.column][from.line] & mask);
    
    // Remove the pieces from "from"
    boardRef->colors[from.column][from.line] >>= numberOfDraggedPieces;
    
    // Make space for the new pieces at "to"
    boardRef->colors[to.column][to.line] <<= numberOfDraggedPieces;
    // Add the new pieces
    boardRef->colors[to.column][to.line] |= colorsToDrag;
    
    boardRef->turn = !boardRef->turn;
    
    if (boardRef->height[to.column][to.line] >= MIX_CORE_NUMBER_OF_PIECES_TO_WIN) {
        // game over!
        boardRef->gameBits |= MIXCoreGameBitsGameOver;
        MIXCorePlayer winnerColor = colorOfSquareAtPosition(boardRef, to, 0);
        if (winnerColor) {
            // That means the bit is set. One of the players is "0", the other one is "1".
            boardRef->gameBits |= MIXCoreGameBitsWinner;
        }
    }
}


bool isSettingPossible(MIXCoreBoardRef boardRef) {
    if (numberOfPiecesForPlayer(boardRef, boardRef->turn) <= 0) {
        return false;
    }
    
    for (uint8_t i = 0; i < LENGTH_OF_BOARD; i++) {
        for (uint8_t j = 0; j < LENGTH_OF_BOARD; j++) {
            MIXCoreSquare square = {i, j};
            if (isSquareEmpty(boardRef, square)) {
                return true;
            }
        }
    }
    return false;
}

void sensibleMoves(MIXCoreBoardRef boardRef, MIXMoveArray *moveArray) {
    core_array_count(*moveArray) = 0;
    MIXCorePlayer player = playerOnTurn(boardRef);
    bool playerHasPiecesLeft = numberOfPiecesForPlayer(boardRef, player) > 0;
    MIXCoreMove lastResortMove = MIXCoreMoveNoMove; // If no other move is found, this will be returned
    // Good: Unrolling the loops brings a big performance boost.
    // Bad: Core.o increases a lot.
#pragma clang loop unroll(full)
    for (int8_t i = 0; i < LENGTH_OF_BOARD; i++) {  // index for column to look at
#pragma clang loop unroll(full)
        for (int8_t j = 0; j < LENGTH_OF_BOARD; j++) { // index for line to look at
            MIXCoreSquare square = {i, j};
            uint8_t height = heightOfSquare(boardRef, square);
            if (height > 4) __builtin_unreachable();  // Otherwise the game would be over. Helps compiler for performance.

            if (height == 0) {
                if (playerHasPiecesLeft) {
                    MIXCoreMove move = MIXCoreMoveMakeSet(square);
                    core_array_push(MIXCoreMove, *moveArray, move);
                }
            } else { // try dragging
                // We know calculate the position of source squares that have the right distance
                // to the target square. Distance needs to be height of target square.
                // There are up to eight directions to look at (up, down, left, right
                // and four diagonals).
                // Some directions we don't want to look at because it's out of the
                // bounds of the board. So let's calculate that.
                int8_t column = i - height;
#pragma clang loop unroll(full)
                for (int8_t columnSignum = -1; columnSignum <= 1; columnSignum++, column += height) {
                    if (column >= 0 && column < LENGTH_OF_BOARD) {
                        int8_t line = j - height;
#pragma clang loop unroll(full)
                        for (int8_t lineSignum = -1; lineSignum <= 1; lineSignum++, line += height) {
                            if (line >= 0 && line < LENGTH_OF_BOARD) {
                                if (columnSignum != 0 || lineSignum != 0) { // don't look at original square
                                    MIXCoreSquare sourceSquare = {column, line};

                                    if (!isSquareEmpty(boardRef, sourceSquare)) {
                                        // So we can drag as long nothing is between. Check that:
                                        if (height == 1 || !isSomethingBetweenSquares(boardRef, square, sourceSquare, columnSignum, lineSignum)) {
                                            uint8_t sourceHeight = heightOfSquare(boardRef, sourceSquare);
                                            if (sourceHeight > 4) __builtin_unreachable();  // Otherwise the game would be over. Helps compiler for performance.

                                            if (height + sourceHeight >= MIX_CORE_NUMBER_OF_PIECES_TO_WIN) {
                                                // Enough pieces to potentially end the game

                                                // First one (for performance reasons not many) move to actually finish it.
                                                MIXCoreMove move = MIXCoreMoveMakeDrag(sourceSquare, square, sourceHeight);
                                                if (player == colorOfSquareAtPosition(boardRef, sourceSquare, 0)) {
                                                    // Player on turn wins; all other moves are not interesting anymore.
                                                    core_array_count(*moveArray) = 0;
                                                    core_array_push(MIXCoreMove, *moveArray, move);
                                                    return;
                                                } else {
                                                    // Losing move. Will be returned if no better move is found
                                                    lastResortMove = move;
                                                }

                                                // Now let's add those moves that don't finish the game
                                                uint8_t sourceHeightFinishing = MIX_CORE_NUMBER_OF_PIECES_TO_WIN - height;
                                                for (uint8_t pieces = 1; pieces < sourceHeightFinishing ; pieces++) {
                                                    if (sourceHeight - pieces != height) {
                                                        // Otherwise the opponent could move directly back and win.
                                                        // On top is a piece of the opponent, otherwise the player could finish it now anyway.
                                                        MIXCoreMove move = MIXCoreMoveMakeDrag(sourceSquare, square, pieces);
                                                        if (! isMoveRevertOfMove(move, boardRef->lastMove)) {
                                                            core_array_push(MIXCoreMove, *moveArray, move);
                                                        }
                                                    }
                                                }
                                            } else {
                                                // Not enough pieces to finish the game. Let's add all possible moves.
                                                for (uint8_t pieces = 1; pieces <= sourceHeight; pieces++) {
                                                    MIXCoreMove move = MIXCoreMoveMakeDrag(sourceSquare, square, pieces);
                                                    if (! isMoveRevertOfMove(move, boardRef->lastMove)) {
                                                        core_array_push(MIXCoreMove, *moveArray, move);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if (!core_array_count(*moveArray)) {
        // no good moves found
        core_array_push(MIXCoreMove, *moveArray, lastResortMove);
    }
}

MIXMoveArray newMoveArray() {
    MIXMoveArray moveArray;
    core_array_init(MIXCoreMove, moveArray);
    return moveArray;
}

void destroyMoveArray(MIXMoveArray moveArray) {
    core_array_free(moveArray);
}


bool isDraggingPossible(MIXCoreBoardRef boardRef) {
    MIXMoveArray moves = newMoveArray();
    sensibleMoves(boardRef, &moves);
    bool dragFound = false;
    while (!dragFound && core_array_count(moves)) {
        MIXCoreMove move = core_array_pop(moves);
        dragFound = isMoveDrag(move);
    }
    destroyMoveArray(moves);
    return dragFound;
}


#pragma mark debug prints

void printLineDivider() {
    for (int i = 0; i < 31; i++) {
        printf("-");
    }
    printf("\n");
}

void printBoardDescription(MIXCoreBoardRef boardRef) {
    for (uint8_t line = 0; line < LENGTH_OF_BOARD; line++) {
        printLineDivider();
        for (uint8_t column = 0; column < LENGTH_OF_BOARD; column++) {
            printf("|");
            MIXCoreSquare square = {column, line};
            uint8_t height = heightOfSquare(boardRef, square);
            for (int8_t positionFromBottom = 0; positionFromBottom < LENGTH_OF_BOARD; positionFromBottom++) {
                if (positionFromBottom >= height) {
                    printf(" ");
                } else {
                    int8_t position = height - positionFromBottom - 1;
                    if (MIXCorePlayerBlack == colorOfSquareAtPosition(boardRef, square, (uint8_t)position)) {
                        printf("X");
                    } else {
                        printf("0");
                    }
                }
            }
        }
        printf("|\n");
    }
    printLineDivider();
}

