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


@property (assign, nonatomic) struct MIXCoreBoard coreBoard;


- (MIXCorePlayer)playerOnTurn;

- (BOOL)isGameOver;

@end
