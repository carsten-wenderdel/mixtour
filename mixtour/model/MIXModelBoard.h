//
//  MIXModelBoard.h
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-18.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MIXCore.h"


@interface MIXModelBoard : NSObject


- (MIXCorePlayer)playerOnTurn;

- (NSUInteger)numberOfPiecesForPlayer:(MIXCorePlayer)player;

- (BOOL)isSquareEmpty:(MIXCoreSquare)square;

- (NSUInteger) heightOfSquare:(MIXCoreSquare)square;

/**
 If this is a legal move, it returns YES.
 If it's an illegal move, the move is not made and NO is returned. The model is still fine.
 */
- (BOOL)setPiece:(MIXCoreSquare)square;

@end
