 //
//  MIXGameView.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-23.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import "MIXGameView.h"
#import "MIXGameView_private.h"

#import "MIXGameBackgroundView.h"
#import "MIXGamePieceView.h"
#import "MIXModelBoard.h"

#define numberOfSquares 5


@interface MIXGameView () {
    NSArray *_fieldArray;
}

@end



@implementation MIXGameView


/**
* Not thread safe!
* Out of bounds exception when square values are too big or too small - better crash than bugs that are hard to find
*/
- (NSMutableArray *)pieceViewArrayForSquare:(MIXCoreSquare)square {
    if (nil == _fieldArray) {
        NSMutableArray *lineArray = [NSMutableArray array];
        for (int line = 0; line < numberOfSquares; line++) {
            NSMutableArray *columnArray = [NSMutableArray array];
            for (int column = 0; column < numberOfSquares; column++) {
                NSMutableArray *viewArray = [NSMutableArray array];
                [columnArray addObject:viewArray];
            }
            [lineArray addObject:[NSArray arrayWithArray:columnArray]];
        }
        _fieldArray = [NSArray arrayWithArray:lineArray];
    }

    NSArray *columnArray = [_fieldArray objectAtIndex:square.line];
    NSMutableArray *viewArray = [columnArray objectAtIndex:square.column];
    return viewArray;
}

- (NSMutableArray *)pieceArrayForView:(MIXGamePieceView *)view {
    if (nil == _fieldArray) {
        return nil;
    }
    for (NSArray *columnArray in _fieldArray) {
        for (NSMutableArray *viewArray in columnArray) {
            for (MIXGamePieceView *pieceView in viewArray) {
                if (pieceView == view) {
                    return viewArray;
                }
            }
        }
    }
    return nil;
}


- (void)clearBoard {
    for (NSArray *columnArray in _fieldArray) {
        for (NSMutableArray *viewArray in columnArray) {
            for (MIXGamePieceView *pieceView in viewArray) {
                NSAssert([pieceView isKindOfClass:[MIXGamePieceView class]], nil);
                [pieceView removeFromSuperview];
            }
        }
    }
}


@end
