//
//  MIXModelBoard.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-18.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import "MIXModelBoard.h"

#import "MIXCoreBoard.h"

@interface MIXModelBoard ()

@property (readonly) struct MIXCoreBoard coreBoard;

@end



@implementation MIXModelBoard


- (id)init {
    self = [super init];
    if (self) {
        resetCoreBoard(&_coreBoard);
    }
    return self;
}


- (MIXCorePlayer)playerOnTurn {
    return playerOnTurn(&_coreBoard);
}


- (NSUInteger)numberOfPiecesForPlayer:(MIXCorePlayer)player {
    return numberOfPiecesForPlayer(&_coreBoard, player);
}


- (BOOL)isSquareEmpty:(MIXCoreSquare)square {
    return isSquareEmpty(&_coreBoard, square);
}


- (NSUInteger)heightOfSquare:(MIXCoreSquare)square {
    return heightOfSquare(&_coreBoard, square);
}


- (MIXCorePlayer)colorOfSquare:(MIXCoreSquare)square atPosition:(uint_fast8_t)position {
    
    return colorOfSquareAtPosition(&_coreBoard, square, position);
}


- (BOOL)setPiece:(MIXCoreSquare)square {
    
    if (! isSquareEmpty(&_coreBoard, square)) {
        return NO;
    }
    
    MIXCorePlayer turn = playerOnTurn(&_coreBoard);
    if (numberOfPiecesForPlayer(&_coreBoard, turn) <= 0) {
       return NO;
    }
    
    // ok, it's a legal move
    setPiece(&_coreBoard, square);
    return YES;
}


- (BOOL)isDragLegalFrom:(MIXCoreSquare)from to:(MIXCoreSquare)to {
    
    return isDragLegal(&_coreBoard, from, to);
}


- (BOOL)dragPiecesFrom:(MIXCoreSquare)from to:(MIXCoreSquare)to
           withNumber:(NSUInteger)numberOfDraggedPieces {
    
    if (isDragLegal(&_coreBoard, from, to)) {
        dragPieces(&_coreBoard, from, to, numberOfDraggedPieces);
        return YES;
    } else {
        return NO;
    }
}




@end
