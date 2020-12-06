//
//  MIXCoreBoard_private.h
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-07-27.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#ifndef mixtour_MIXCoreBoard_private_h
#define mixtour_MIXCoreBoard_private_h


#include "MIXCoreBoard.h"


/**
 Not intended for normal game play but for unit tests and similar.
 Does not change whose turn it is.
 */
void setPiecesDirectlyWithList(MIXCoreBoardRef boardRef, MIXCoreSquare square, int numberOfArguments, va_list ap);


/**
 Not intended for normal game play but for unit tests and similar.
 Does not change whose turn it is.
 */
void setPiecesDirectly(MIXCoreBoardRef boardRef, MIXCoreSquare square, int numberOfArguments, ...);


/**
 Not intended for normal game play but for unit tests and similar.
 */
void setTurnDirectly(MIXCoreBoardRef boardRef, MIXCorePlayer turn);


#endif
