//
//  MIXGameView_protected.h
//  mixtour
//
//  Created by Carsten Wenderdel on 2014-12-09.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

@class MIXGamePieceView;

@interface MIXGameView()

@property (nonatomic, readonly) CGFloat pieceHeight;

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)handlePressGesture:(UILongPressGestureRecognizer *)gestureRecognizer;
- (MIXCoreSquare)squareForPosition:(CGPoint)position;
- (NSMutableArray *)pieceArrayForView:(MIXGamePieceView *)view;

@end
