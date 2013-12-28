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

@property (nonatomic, readonly) CGPoint upperLeftPoint;
@property (nonatomic, readonly) CGFloat boardLength;
@property (nonatomic, readonly) CGFloat squareLength;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, weak) UIView *pannedView;

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
        
        [self addGestureRecognizers];
    }
    return self;
}


- (void)addGestureRecognizers {
    UILongPressGestureRecognizer *pressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                         action:@selector(handlePressGesture:)];
    pressGestureRecognizer.delegate = self;
    pressGestureRecognizer.minimumPressDuration = 0.3;
    [self addGestureRecognizer:pressGestureRecognizer];
    self.longPressGestureRecognizer = pressGestureRecognizer;

    UIPanGestureRecognizer *thePanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(handlePanGesture:)];
    thePanGestureRecognizer.delegate = self;
    thePanGestureRecognizer.maximumNumberOfTouches = thePanGestureRecognizer.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:thePanGestureRecognizer];
    self.panGestureRecognizer = thePanGestureRecognizer;
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

#pragma mark GestureRecognizer Actions

- (void)handlePressGesture:(UILongPressGestureRecognizer *)gestureRecognizer {
    NSLog(@"handlePressGesture, state: %d", gestureRecognizer.state);
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint currentPoint = [gestureRecognizer locationInView:self];
            UIView *upperMostView = [self hitTest:currentPoint withEvent:nil];
            if ([upperMostView isKindOfClass:[MIXGamePieceView class]]) {
                self.pannedView = upperMostView;
                self.pannedView.alpha = 0.4f;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            self.pannedView.alpha = 1.0f;
            self.pannedView = nil;
            break;
        default:
            break;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    NSLog(@"handlePanGesture, state: %d", gestureRecognizer.state);
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        case UIGestureRecognizerStateEnded:
            self.pannedView.center = [gestureRecognizer locationInView:self];
            break;
        default:
            break;
    }
}

#pragma mark UIGestureRecognizer Delegate Methods

 - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
         shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
     return YES;
 }

@end
