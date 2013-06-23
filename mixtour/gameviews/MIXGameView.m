 //
//  MIXGameView.m
//  mixtour
//
//  Created by Carsten Wenderdel on 2013-06-23.
//  Copyright (c) 2013 Carsten Wenderdel. All rights reserved.
//

#import "MIXGameView.h"

#import "MIXGameBackgroundView.h"
#import "MIXGamePieceView.h"
#import "MIXModelBoard.h"

#define numberOfSquares 5


@interface MIXGameView ()

@property (readonly) CGPoint upperLeftPoint;
@property (readonly) CGFloat boardLength;
@property (readonly) CGFloat squareLength;

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
        
        [self setPiecesForBoard:[self boardForTryingOut]];
        
    }
    return self;
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
}



- (void)setPiecesForBoard:(MIXModelBoard *)board {
    
    for (int column = 0; column < numberOfSquares; column++) {
        for (int line = 0; line < numberOfSquares; line++) {
            MIXCoreSquare square = MIXCoreSquareMake(column, line);
            NSUInteger height = [board heightOfSquare:square];
            for (int position = height - 1; position >= 0; position--) {
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


- (void)setPieceWithColor:(UIColor *)color
                 onSquare:(MIXCoreSquare)square
             atUIPosition:(NSUInteger)uiPosition {
    
    CGFloat pieceWidth = self.squareLength * 0.7f;
    CGFloat pieceHeight = self.squareLength * 0.17f;
    CGFloat startX = self.upperLeftPoint.x
            + self.squareLength * square.line
            + ((self.squareLength - pieceWidth) / 2.0f);
    CGFloat startY = self.upperLeftPoint.y
            + self.squareLength * (square.column + 0.9)
            - pieceHeight * (uiPosition + 1);
    CGRect pieceFrame = CGRectMake(startX, startY, pieceWidth, pieceHeight);
    
    MIXGamePieceView *pieceView = [[MIXGamePieceView alloc] initWithFrame:pieceFrame
                                                                withColor:color];
    [self addSubview:pieceView];
}


- (MIXModelBoard *)boardForTryingOut
{
    MIXModelBoard *board = [[MIXModelBoard alloc] init];
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            [board setPiece:MIXCoreSquareMake(i, j)];
        }
    }
    
    for (int i = 1; i <=2; i++) {
        for (int j = 0; j <= 3; j++) {
            [board dragPiecesFrom:MIXCoreSquareMake(i, j)
                               to:MIXCoreSquareMake(i, j+1)
                       withNumber:j+1];
        }
    }
    return board;
}


@end
