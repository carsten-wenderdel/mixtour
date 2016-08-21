//
//  MIXCoreBoard.c
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-17.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//


#include "MIXCoreBoard.h"

#include <stdlib.h>
#include "MIXCoreHelper.h"


#define MIX_CORE_NUMBER_OF_PIECES_OF_ONE_COLOR 20
#define MIX_CORE_NUMBER_OF_PIECES_TO_WIN 5


enum MIXCoreGameBits {
    MIXCoreGameBitsWinner = 1,
    MIXCoreGameBitsGameOver = 1 << 1
    
};
typedef enum MIXCoreGameBits MIXCoreGameBits;



void dragPieces(MIXCoreBoardRef boardRef, MIXCoreSquare from, MIXCoreSquare to, uint8_t numberOfDraggedPieces);

    

void resetCoreBoard(MIXCoreBoardRef boardRef) {
    
    *boardRef = (struct MIXCoreBoard){0};
    boardRef->turn = MIXCorePlayerWhite;
    boardRef->whitePieces = boardRef->blackPieces = MIX_CORE_NUMBER_OF_PIECES_OF_ONE_COLOR;
}


MIXCorePlayer playerOnTurn(MIXCoreBoardRef boardRef) {
    
    return boardRef->turn;
}


bool isGameOver(MIXCoreBoardRef boardRef)
{
    return (boardRef->gameBits & MIXCoreGameBitsGameOver) != 0;
}


MIXCorePlayer winner(MIXCoreBoardRef boardRef)
{
    if (isGameOver(boardRef)) {
        return boardRef->gameBits & MIXCoreGameBitsWinner;
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
    
    // All colors at that position encoded in on integer variable:
    uint8_t color = boardRef->colors[square.column][square.line];
    // Shift colors to the right so that the important bit is at the very right:
    color >>= position;
    // Set all other bits which are not at the very right to zero:
    color &= 1;
    // return value will be either 0 or 1
    return (MIXCorePlayer)color;
}


/**
 Does not check whether setting is legal.
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


bool isDistanceRight(MIXCoreBoardRef boardRef, MIXCoreSquare from, MIXCoreSquare to) {
    
    uint8_t height = boardRef->height[to.column][to.line];
    
    if (from.column == to.column) {
        if (abs(from.line - to.line) == height) {
            return true; // vertical drag
        } else {
            return false;
        }
    }
    if (abs(from.column - to.column) == height) {
        if (from.line == to.line) {
            return true; // horizontal drag
        } else if (abs(from.line - to.line) == height) {
            return true; // cross drag
        }
    }
    return false;
}


bool isAPieceBetween(MIXCoreBoardRef boardRef, MIXCoreSquare from, MIXCoreSquare to) {

    int8_t columnSignum = signum((int8_t)to.column - from.column);
    int8_t lineSignum = signum((int8_t)to.line - from.line);
    
    uint8_t columnToCheck = (uint8_t)(from.column + columnSignum);
    uint8_t lineToCheck = (uint8_t)(from.line + lineSignum);
    // don't use "<" or ">" for comparison - increments could be positive or
    // negative we could come from any side.
    // Also we need to check both column and line as one increment could be 0.
    while (columnToCheck != to.column && lineToCheck != to.line) {
        if (boardRef->height[columnToCheck][lineToCheck] != 0u) {
            return true; // a piece is between
        }
        columnToCheck += columnSignum;
        lineToCheck += lineSignum;
    }
    
    return false; // nothing found
}


bool isMoveLegal(MIXCoreBoardRef boardRef, MIXCoreMove move) {

    if (isMoveDrag(move)) {

        if (isMoveRevertOfMove(move, boardRef->lastMove)) {
            return false;
        }
        
        MIXCoreSquare from = move.from;
        MIXCoreSquare to = move.to;
        
        if (from.column == to.column && from.line == to.line) {
            return false;
        }
        
        if (!isDistanceRight(boardRef, from, to)) {
            return false;
        }
        
        uint8_t height = boardRef->height[to.column][to.line];
        if (1u == height) {
            // drag to field right next => no piece between => legal
            return true;
        }
        
        if (isAPieceBetween(boardRef, from, to)) {
            return false;
        }
        
        return true; // nothing found, looks good
        
    } else {
        
        MIXCoreSquare square = move.to;
        
        if (! isSquareEmpty(boardRef, square)) {
            return false;
        }
        
        MIXCorePlayer player = playerOnTurn(boardRef);
        if (numberOfPiecesForPlayer(boardRef, player) <= 0) {
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
            return colorOfSquareAtPosition(boardRef, move.to, 0);
        }
    }
    return MIXCorePlayerUndefined;
}

void makeMove(MIXCoreBoardRef boardRef, MIXCoreMove move) {
    if (isMoveDrag(move)) {
        dragPieces(boardRef, move.from, move.to, move.numberOfPieces);
    } else {
        setPiece(boardRef, move.to);
    }
    boardRef->lastMove = move;
}


/**
 Does not check whether move is legal.
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


MIXMoveArray arrayOfLegalDragMoves(MIXCoreBoardRef boardRef) {
    MIXMoveArray moveArray;
    kv_init(moveArray);
    for (uint8_t i = 0; i < LENGTH_OF_BOARD; i++) {
        for (uint8_t j = 0; j < LENGTH_OF_BOARD; j++) {
            MIXCoreSquare square = {i, j};
            uint8_t height = heightOfSquare(boardRef, square);
            if (height > 0) {
                for (int8_t columnSignum = -1; columnSignum <= 1; columnSignum++) {
                    for (int8_t lineSignum = -1; lineSignum <= 1; lineSignum++) {
                        if (columnSignum != 0 || lineSignum != 0) { // don't look at orignal square
                            MIXCoreSquare sourceSquare = {(uint8_t)(i + height*columnSignum), (uint8_t)(j + height*lineSignum)};
                            // When the result is normally negative, we have a overflow, -1 becomes 255
                            // So we don't have to ask for negative numbers, both 6 and 255 is beyond the board
                            if (sourceSquare.column < LENGTH_OF_BOARD && sourceSquare.line < LENGTH_OF_BOARD) {
                                if (!isSquareEmpty(boardRef, sourceSquare)) {
                                    // So we can drag as long nothing is between. Check that:
                                    if (!isSomethingBetweenSquares(boardRef, square, sourceSquare, columnSignum, lineSignum)) {
                                        for (uint8_t pieces = heightOfSquare(boardRef, sourceSquare); pieces >= 1; pieces--) {
                                            MIXCoreMove move = MIXCoreMoveMakeDrag(sourceSquare, square, pieces);
                                            if (! isMoveRevertOfMove(move, boardRef->lastMove)) {
                                                kv_push(MIXCoreMove, moveArray, move);
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
    return moveArray;
}

MIXMoveArray arrayOfLegalMoves(MIXCoreBoardRef boardRef) {
    // dragMoves:
    MIXMoveArray moveArray = arrayOfLegalDragMoves(boardRef);
    
    // add SetMoves:
    if (numberOfPiecesForPlayer(boardRef, boardRef->turn) > 0) {
        for (uint8_t i = 0; i < LENGTH_OF_BOARD; i++) {
            for (uint8_t j = 0; j < LENGTH_OF_BOARD; j++) {
                MIXCoreSquare square = {i, j};
                if (isSquareEmpty(boardRef, square)) {
                    MIXCoreMove move = MIXCoreMoveMakeSet(square);
                    kv_push(MIXCoreMove, moveArray, move);
                }
            }
        }
    }
    return moveArray;
}


void destroyMoveArray(MIXMoveArray moveArray) {
    kv_destroy(moveArray);
}


bool isDraggingPossible(MIXCoreBoardRef boardRef) {
    MIXMoveArray dragMoves = arrayOfLegalDragMoves(boardRef);
    size_t numberOfMoves = kv_size(dragMoves);
    destroyMoveArray(dragMoves);
    return numberOfMoves > 0;
}


