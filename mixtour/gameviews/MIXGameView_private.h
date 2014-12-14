//
//  MIXGameView_protected.h
//  mixtour
//
//  Created by Carsten Wenderdel on 2014-12-09.
//  Copyright (c) 2014 Carsten Wenderdel. All rights reserved.
//

@interface MIXGameView()

@property (nonatomic, strong) NSArray *pannedViews;
@property (nonatomic, readonly) CGFloat pieceHeight;

- (void)handlePanGesture:(UIPanGestureRecognizer *)gestureRecognizer;

@end
