//
//  MIXCoreBoard_private.c
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-07-27.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#include "MIXCoreBoard_private.h"

#include <stdarg.h>


void setPiecesDirectlyWithList(MIXCoreBoardRef boardRef, MIXCoreSquare square, int numberOfArguments, va_list ap) {
    boardRef->height[square.column][square.line] += numberOfArguments;
    
    for (int i = 0; i < numberOfArguments; i++) {
        MIXCorePlayer color = va_arg(ap, MIXCorePlayer);
        
        boardRef->colors[square.column][square.line] <<= 1;
        if (MIXCorePlayerWhite == color) {
            boardRef->whitePieces--;
        } else {
            boardRef->colors[square.column][square.line] |= 1;
            boardRef->blackPieces--;
        }
    }
}


void setPiecesDirectly(MIXCoreBoardRef boardRef, MIXCoreSquare square, int numberOfArguments, ...) {
    va_list ap;
    va_start(ap, numberOfArguments);
    
    setPiecesDirectlyWithList(boardRef, square, numberOfArguments, ap);
    
    va_end(ap);
}



void setTurnDirectly(MIXCoreBoardRef boardRef, MIXCorePlayer turn) {
    
    boardRef->turn = turn;
}
