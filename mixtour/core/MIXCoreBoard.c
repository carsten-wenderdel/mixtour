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

    int8_t columnIncrement = signum(to.column - from.column);
    int8_t lineIncrement = signum(to.line - from.line);
    
    uint8_t columnToCheck = from.column + columnIncrement;
    uint8_t lineToCheck = from.line + lineIncrement;
    // don't use "<" or ">" for comparison - increments could be positive or
    // negative we could come from any side.
    // Also we need to check both column and line as one increment could be 0.
    while (columnToCheck != to.column && lineToCheck != to.line) {
        if (boardRef->height[columnToCheck][lineToCheck] != 0u) {
            return true; // a piece is between
        }
        columnToCheck += columnIncrement;
        lineToCheck += lineIncrement;
    }
    
    return false; // nothing found
}


bool isMoveLegal(MIXCoreBoardRef boardRef, MIXCoreMove move) {

    if (isMoveDrag(move)) {
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

void makeMove(MIXCoreBoardRef boardRef, MIXCoreMove move) {
    if (isMoveDrag(move)) {
        dragPieces(boardRef, move.from, move.to, move.numberOfPieces);
    } else {
        setPiece(boardRef, move.to);
    }
}


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

