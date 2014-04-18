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


@interface MIXGameView () {
    NSArray *_fieldArray;
}

@property (nonatomic, readonly) CGPoint upperLeftPoint;
@property (nonatomic, readonly) CGFloat boardLength;
@property (nonatomic, readonly) CGFloat squareLength;
@property (nonatomic, readonly) CGFloat pieceWidth;
@property (nonatomic, readonly) CGFloat pieceHeight;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) NSArray *pannedViews;

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
    _pieceWidth = _squareLength * 0.7f;
    _pieceHeight = _squareLength * 0.17f;
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
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    MIXCoreSquare square = [self squareForPosition:currentPoint];
    NSLog(@"handlePressGesture at square %d/%d, state: %d", square.line, square.column, gestureRecognizer.state);
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            UIView *upperMostView = [self hitTest:currentPoint withEvent:nil];
            if ([upperMostView isKindOfClass:[MIXGamePieceView class]]) {
                NSMutableArray *viewsToPan = [NSMutableArray array];
                NSArray *viewArray = [self pieceArrayForView:(MIXGamePieceView *)upperMostView];
                BOOL viewNeedsToBePanned = NO;
                for (MIXGamePieceView *pieceView in viewArray) {
                    if (pieceView == upperMostView) {
                        viewNeedsToBePanned = YES;
                    }
                    if (viewNeedsToBePanned) {
                        [viewsToPan addObject:pieceView];
                        pieceView.alpha = 0.4f;
                    }
                }
                self.pannedViews = viewsToPan;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            for (MIXGamePieceView *view in self.pannedViews) {
                view.alpha = 1.0f;
            }
            self.pannedViews = nil;
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
        case UIGestureRecognizerStateEnded: {
            CGPoint center = [gestureRecognizer locationInView:self];
            for (MIXGamePieceView *view in self.pannedViews) {
                view.center = center;
                center.y -= _pieceHeight;
            }
            break;
        }
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
