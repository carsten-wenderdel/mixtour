//
//  MIXModelBoard.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-18.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import "MIXModelBoard.h"

#import "MIXCoreBoard.h"


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


- (BOOL)isGameOver {
    return isGameOver(&_coreBoard);
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


@end
