//
//  MIXCoreBoard.c
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-17.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//


#include "MIXCoreBoard.h"


#define NUMBER_OF_PIECES_OF_ONE_COLOR 25


MIXCoreSquare MIXCoreSquareMake(uint8_t column, uint8_t line) {
    MIXCoreSquare square = {column, line};
    return square;
}


void resetCoreBoard(MIXCoreBoardRef boardRef) {
    
    *boardRef = (struct MIXCoreBoard){0};
    boardRef->turn = MIXCorePlayerWhite;
    boardRef->whitePieces = boardRef->blackPieces = NUMBER_OF_PIECES_OF_ONE_COLOR;
}


MIXCorePlayer playerOnTurn(MIXCoreBoardRef boardRef) {
    
    return boardRef->turn;
}


uint8_t numberOfPiecesForPlayer(MIXCoreBoardRef boardRef, MIXCorePlayer player) {
    
    switch (player) {
        case MIXCorePlayerWhite:
            return boardRef->whitePieces;
        default:
            return boardRef->blackPieces;
    }
}


bool isSquareEmpty(MIXCoreBoardRef boardRef, MIXCoreSquare square) {
    
   return (0 == boardRef->height[square.column][square.line]);
}


uint8_t heightOfSquare(MIXCoreBoardRef boardRef, MIXCoreSquare square) {
    
    return boardRef->height[square.column][square.line];
}


MIXCorePlayer colorOfSquareAtPosition(MIXCoreBoardRef boardRef, MIXCoreSquare square, uint_fast8_t position) {
    
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


void movePiece(MIXCoreBoardRef boardRef, MIXCoreSquare from, MIXCoreSquare to, uint8_t numberOfMovedPieces) {

    boardRef->height[from.column][from.line] -= numberOfMovedPieces;
    boardRef->height[to.column][to.line] += numberOfMovedPieces;
    
    // Make a mask that has zeros for the last "numberOfMovedPieces" bits, ones everywhere else
    uint8_t mask = UINT8_MAX << numberOfMovedPieces;
    // now the last bits are set, the others not.
    mask = ~mask;
    // Remove all bits of those positions which are not removed.
    // In the last bits we then have the important information, 0 for white, 1 for black
    uint8_t colorsToMove = (boardRef->colors[from.column][from.line] & mask);
    
    // Remove the pieces from "from"
    boardRef->colors[from.column][from.line] >>= numberOfMovedPieces;
    
    // Make space for the new pieces at "to"
    boardRef->colors[to.column][to.line] <<= numberOfMovedPieces;
    // Add the new pieces
    boardRef->colors[to.column][to.line] |= colorsToMove;
}

