//
//  MIXCore.h
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-18.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//


/**
 This header file is for both Objective-C classes accessing the model and
 the C-part of the project.
 */


#ifndef mixtour_MIXCore_h
#define mixtour_MIXCore_h


typedef enum {
    MIXCorePlayerWhite = 0,
    MIXCorePlayerBlack = 1,
    MIXCorePlayerUndefined = -1
} MIXCorePlayer;


typedef struct {
    uint8_t column;
    uint8_t line;
} MIXCoreSquare;


MIXCoreSquare MIXCoreSquareMake(uint8_t column, uint8_t line);


#endif
