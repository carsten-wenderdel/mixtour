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

@property (nonatomic, readonly) CGPoint upperLeftPoint;
@property (nonatomic, readonly) CGFloat boardLength;
@property (nonatomic, readonly) CGFloat squareLength;
@property (nonatomic, readonly) CGFloat pieceWidth;

@property (nonatomic, strong) NSMutableArray *pieceViews;

@end



@implementation MIXGameView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self calculatePropertiesDependentOnFrame];
        
        // Background view:
        CGRect backgroundRect = CGRectMake(self.upperLeftPoint.x,
                                           self.upperLeftPoint.y,
                                           self.boardLength,
                                           self.boardLength);
        MIXGameBackgroundView *backgroundView = [[MIXGameBackgroundView alloc] initWithFrame:backgroundRect];
        [self addSubview:backgroundView];
    }
    return self;
}

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


- (void)calculatePropertiesDependentOnFrame {
    CGRect frame = self.frame;
    
    _boardLength = MIN(frame.size.height, frame.size.width);
    
    if (frame.size.height > frame.size.width) {
        // portrait view
        CGFloat emptyVerticalSpace = (frame.size.height - _boardLength) / 2.0f;
        _upperLeftPoint = CGPointMake(0, emptyVerticalSpace);
    } else {
        // landscape view
        CGFloat emptyHorizontalSpace = (frame.size.width - _boardLength) / 2.0f;
        _upperLeftPoint = CGPointMake(emptyHorizontalSpace, 0);
    }
    
    _squareLength = _boardLength / (CGFloat)numberOfSquares;
    _pieceWidth = _squareLength * 0.7f;
    _pieceHeight = _squareLength * 0.17f;
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

- (void)setPiecesForBoard:(MIXModelBoard *)board {
    
    for (int column = 0; column < numberOfSquares; column++) {
        for (int line = 0; line < numberOfSquares; line++) {
            MIXCoreSquare square = MIXCoreSquareMake(column, line);
            NSInteger height = [board heightOfSquare:square];
            for (NSInteger position = height - 1;
                 position >= 0;
                 position--) {
                MIXCorePlayer player = [board colorOfSquare:square atPosition:position];
                UIColor *color = (MIXCorePlayerWhite == player) ?
                [UIColor yellowColor] :
                [UIColor redColor];
                // When there are 5 pieces, the upper most has - as always -
                // the position 0, but the ui position 4
                NSUInteger uiPosition = height - position - 1;
                [self setPieceWithColor:color onSquare:square atUIPosition:uiPosition];
            }
        }
    }
}


- (MIXCoreSquare)squareForPosition:(CGPoint)position {
    MIXCoreSquare square;
    square.line = (int)((position.x - self.upperLeftPoint.x) / self.squareLength);
    square.column = (int)((position.y - self.upperLeftPoint.y) / self.squareLength);
    return square;
}


- (void)setPieceWithColor:(UIColor *)color
                 onSquare:(MIXCoreSquare)square
             atUIPosition:(NSUInteger)uiPosition {

    CGFloat startX = self.upperLeftPoint.x
            + self.squareLength * square.line
            + ((self.squareLength - _pieceWidth) / 2.0f);
    CGFloat startY = self.upperLeftPoint.y
            + self.squareLength * (square.column + 0.9)
            - _pieceHeight * (uiPosition + 1);
    CGRect pieceFrame = CGRectMake(startX, startY, _pieceWidth, _pieceHeight);
    
    MIXGamePieceView *pieceView = [[MIXGamePieceView alloc] initWithFrame:pieceFrame
                                                                withColor:color];
    [self addSubview:pieceView];
    
    NSMutableArray *viewArray = [self pieceViewArrayForSquare:square];
    [viewArray addObject:pieceView];
}


@end
